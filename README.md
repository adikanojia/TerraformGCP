# TerraformGCP

What is Terraform? 

A tool that helps you create and manage your cloud infrastructure using code. It allows you to define your desired infrastructure state in configuration files, and then Terraform takes care of creating and managing the necessary resources in the cloud. It makes it easier to set up and maintain your infrastructure in a consistent and reproducible way. 

What is a user-managed Vertex AI Notebook? 

A web-based tool that provides a flexible and customizable environment for writing, running, and collaborating on machine learning code and models in the cloud. 

What is a private Google cloud storage bucket with a retention policy? 

A secure digital storage space that keeps your files safe and prevents them from being changed or deleted for a certain period of time. It helps protect your data and ensures that it is retained as needed for compliance or other purposes. The "retention policy" refers to a rule that specifies how long the files or objects stored in the bucket should be kept before they can be modified, deleted, or permanently removed. 

What is a BigQuery dataset which includes a configured optimisation that could speed up queries? 

A BigQuery dataset is like a collection of organized tables and data stored in Google's BigQuery data warehouse. It's a way to keep your data in one place for easy management and analysis. When we talk about a BigQuery dataset with a configured optimization to speed up queries, it means that certain settings or configurations have been applied to the dataset to make queries run faster. 

Step 1: Init 

After getting the answers to these questions I began doing courses. I skimmed through a short course overviewing GCP and its services as well as how it's products translate to AWS products. 

Then I began a course on Terraform. I wanted to play around with Terraform while I was learning so it wasn’t just continuous videos, but I could learn more hands-on so I installed Terraform using the guidance in the course. I installed it using Chocolatey so I had to install that first. I then went in circles around several courses on how to actually start working with Terraform for hours. 

After a lot of confusion, I found a YouTube video (https://youtu.be/e_8LZL2Th_4) which while I couldn’t fully follow along, I sort of got the gist of. After rewatching it like a dozen times I attempted to try again. I used A Cloud Guru to get access to a Google console. I then downloaded an access key from the service account under IAM & Admin as a JSON file. I then created a terraform folder using the terminal, moved the json file inside and renamed it “credentials.json”. 

I then opened the keys content on VSCode. I created a “main.tf” file and inserted the provider block and proceeded to initialise Terraform. I then started doing more research on Vertex AI Notebook and BigQuery. I discovered they sat in the middle of the spectrum from totally customisable to fully managed as they provided customisability yet had a managed infrastructure. 

I began enabling Vertex AI API from the Google console. Then my connection died so I restarted the entire process but this time after creating my own GCP account under the free tier. I followed the steps listed here -> https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build . I enabled GCE, created a service account and got an access key. I followed the steps and replaced the project_id, region and file path. Then after initialising, I used terraform fmt and validate to remove any errors before applying. 

Step 2: Vertex  

https://cloud.google.com/vertex-ai/docs/tutorials/terraform/terraform-create-user-managed-notebooks-instance 

I began by enabling Vertex AI API, I then followed the steps outlined and applied. An error returned because I hadn’t enabled Cloud Resource Manager API. I applied again and it was successful. 

Step 3: Bucket 

https://cloud.google.com/storage/docs/terraform-create-bucket-upload-object 

Again, followed steps outlined but faced the error below. 

googleapi: Error 409: The requested bucket name is not available. The bucket namespace is shared by all users of the system. Please select a different name and try again., conflict. 
I changed the name of the google storage bucket to my-bucket-buddy. This seemed to resolve that issue but I was faced with another. 

Error: open ~/terraform1/sample_file.txt: The system cannot find the path specified. 

After being stuck for a while, I just kept trying random things until something worked, it seems there’s an error in the Google docs. As when typing the source of the text file to be uploaded to the bucket you do not provide a path as instructed, only the file name.  Then, I searched for how to insert a retention policy and came across a stackoverflow query -> https://stackoverflow.com/questions/63443220/configure-retention-policy-for-gcp-storage-bucket-using-terraform . I used this to insert a retention policy into my google storage bucket.  

Step 4: BigQuery 

https://cloud.google.com/blog/products/infrastructure/iam-policy-for-bigquery-dataset-authorized-views-terraform 

I did more research into each line of code to fully understand it. I studied BigQuery datasets and how to optimize them. I ran into a lot of roadblocks but eventually I found this obscure page which helped a lot. 

http://broadoakdata.uk/load-data-bigquery-terraform/ 

Creating the BigQuery dataset wasn’t too difficult after learning how schemas and csv files work. I made my own dataset in a csv file and made my own schema.  

But then I ran into the main challenge of this task -- partitioning. After hours of research and testing I still couldn’t find a way to partition the data. What annoys me is that I see complex examples of code which incorporate partitioning directly from Terraform into filled datsets, but I just don’t understand the code at all. So I decided I’ll just make two separate tables. One where I import my dataset and an empty dataset with partitions. This section was by far the most challenging but it was fun to play with the data and create your own schema. Once I understood how to import data into new BigQuery tables, the task wasn't too difficult. I made the first letter of all the data items spell out Lloyd’s Banking Group.  Once all the tasks were completed I spent some time understanding the theory behind all the infrasture from Cloud Guru videos and how the reources work together to facilitate a complete machine learning pipeline. I also tried to manipulate the data using Vertex AI but again this seemed impossible to do directly from Terraform.

Google Vertex AI notebooks, Google Cloud Storage buckets, and BigQuery datasets can be used together in a project to facilitate a complete machine learning pipeline. Here's a high-level overview of how these components can work together: 

Data Storage and Preprocessing: 

Data is stored in Google Cloud Storage buckets, providing a scalable and durable storage solution for your raw or processed data. You can upload, organize, and manage your datasets within buckets. 

If required, you can preprocess and transform the data using tools or libraries of your choice, potentially utilizing Google Cloud Dataflow or other data processing services. 

Data Analysis and Modeling: 

Google Vertex AI notebooks provide an interactive and collaborative environment to develop and experiment with machine learning models. You can use notebooks to write and execute code, explore data, build and train models, and analyze results. 

The notebooks can read data from Google Cloud Storage buckets or directly from BigQuery datasets. You can leverage BigQuery's SQL capabilities to perform data analysis, create derived datasets, and extract features for modeling. 

Model Training and Deployment: 

Once you have developed and tested your machine learning models within the Vertex AI notebooks, you can train them using the powerful distributed training capabilities of Google Vertex AI. 

During training, you can fetch and preprocess data from BigQuery datasets or Google Cloud Storage buckets, feeding it to the training job. 

After training, you can deploy the trained models as Vertex AI endpoints for real-time predictions or batch predictions, depending on your use case. 

Data Warehousing and Analytics: 

BigQuery datasets act as a data warehouse, enabling scalable and performant analytics on large datasets. You can store processed data, intermediate results, or aggregated data from various sources within BigQuery datasets. 

The processed or transformed data can be loaded into BigQuery tables for further analysis, reporting, and visualization. You can run SQL queries, build complex analytics pipelines, or connect BigQuery to visualization tools like Google Data Studio for data exploration and reporting. 

By combining Google Vertex AI notebooks, Google Cloud Storage buckets, and BigQuery datasets, you can seamlessly integrate the different stages of your machine learning pipeline—from data storage and preprocessing to analysis, modeling, and deployment—providing a unified and scalable environment for end-to-end machine learning workflows within the Google Cloud platform. 
