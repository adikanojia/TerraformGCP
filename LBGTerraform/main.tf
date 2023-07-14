# Google Cloud Storage buckets, Google Vertex AI notebooks and BigQuery datasets 
# can be used together in a project to facilitate a complete machine learning pipeline.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("credentials1.json")
  project     = "rare-chiller-391817"
  region      = "europe-west2"
}

# This code creates a storage bucket where raw data or processed 
# datasets can be uploaded, organised and managed

resource "google_storage_bucket" "my-sto-bucket" {
  name                        = "my-sto-bucket"
  project                     = "rare-chiller-391817"
  location                    = "europe-west2"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  retention_policy {
    retention_period = 5 # 5 second retention period
  }
}

# This code allows sample data to stored in a 
# Google Storage Bucket. 

resource "google_storage_bucket_object" "sample_data" {
  name         = "sample-data"
  source       = "sampledata.csv"
  content_type = "CSV"
  bucket       = google_storage_bucket.my-sto-bucket.id
  depends_on = [
    google_storage_bucket.my-sto-bucket,
  ]
}

# This code creates a BigQuery dataset which acts as a data warehouse, 
# enabling scalable and performant analytics on large datasets

resource "google_bigquery_dataset" "default" {
  dataset_id                 = "my_dataset"
  project                    = "rare-chiller-391817"
  location                   = "europe-west2"
  delete_contents_on_destroy = true
  depends_on = [
    google_storage_bucket_object.sample_data,
  ]
}

# The processed or transformed data can be loaded into BigQuery 
# tables for further analysis, reporting and visualisation

resource "google_bigquery_table" "table_tf" {
  project             = "rare-chiller-391817"
  dataset_id          = google_bigquery_dataset.default.dataset_id
  deletion_protection = false
  table_id            = "tabletf"
  schema = file("schema.json")
  labels = {
    env = "default"
  }
  external_data_configuration {
    autodetect    = true
    source_format = "CSV"
      csv_options {
        quote = "\""
        skip_leading_rows = 1
      }
    source_uris = [
      "gs://my-sto-bucket/sample-data",
    ]
  }
  depends_on = [
    google_bigquery_dataset.default,
  ]
}

# Partitioning cannot be specified for external data but
# an empty dataset can be created with partitions

resource "google_bigquery_table" "partitioned_table_tf" {
  project             = "rare-chiller-391817"
  dataset_id          = google_bigquery_dataset.default.dataset_id
  deletion_protection = false
  table_id            = "partitionedtabletf"
  labels = {
    env = "default"
  }
  schema = file("schema.json")
  time_partitioning {
    type = "YEAR"
    field = "Date Manufactured"
  }
  range_partitioning {
    field = "Quantity Sold"
    range {
      start = 0
      end = 250
      interval = 50
    }
  }
}

# This resource blocks below provision a Notebook which can be used to explore data 
# from the bucket to build and train models, analyse results and execute code

resource "google_project_service" "notebooks" {
  provider           = google
  service            = "notebooks.googleapis.com"
  disable_on_destroy = false
}

# Vertex AI Notebooks can take data from Google Storage Buckets
# and BigQuery to perform data analysis, create derived datasets
# and extract features for modeling

resource "google_notebooks_instance" "my_notebook_instance" {
  name         = "my-notebook-instance"
  project      = "rare-chiller-391817"
  provider     = google
  location     = "europe-west2-a"
  machine_type = "e2-small"
  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-ent-2-9-cu113-notebooks"
  }
  depends_on = [
    google_project_service.notebooks
  ]
}