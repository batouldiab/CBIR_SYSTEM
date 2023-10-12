# CBIR_SYSTEM: Image Processing System for Animal Image Classification

This image processing system is designed to classify animal images using a combination of color histograms and Gabor filters for feature extraction. The system provides a graphical user interface (GUI) that allows users to select an image for classification and compare it against a dataset of animal images. The system calculates similarity values and Euclidean distances to perform the classification.

## Image Preprocessing:

### Color Histograms:
- The input images are first converted to the HSV (Hue, Saturation, Value) color space.
- A color histogram is computed to represent the distribution of pixel values in the HSV color channels.
- The histograms are used as features for image classification.

### Gabor Filters:
- Gabor filters are applied to grayscale versions of the input images.
- Gabor filters are used to capture texture and edge information in images.
- Mean and standard deviation features are extracted from the filtered images.

## Feature Extraction Methods:

- **Color Histograms:**
  - Color histograms capture color distribution information in the images.
  - Histogram equalization is applied to enhance the color contrast.
  - The histograms are quantized and used as features.

- **Gabor Filters:**
  - Gabor filters are applied to capture texture patterns in the images.
  - Mean and standard deviation values of the filtered images are used as features.

## How to Use:

1. **Downloading the Dataset:**
   - Download the dataset used in the project from the following link: [Animal Image Dataset](https://www.csc.kth.se/~heydarma/Datasets.html) (or use the animal_database folder already uploaded in this directory).
   - **Note:** The system will only work with this specific dataset, or the project must be edited accordingly.

2. **Graphic User Interface (GUI) Options:**
   - **Single Image Prediction using Content-Based Image Retrieval (CBIR):**
     - User chooses the image using the "Browse Image" button. The image is displayed in the GUI.
     - User chooses the database folder used for prediction using the "Select Database Folder" button.
     - User presses the "Find Similar Images" button and waits for the resulting most 9 similar images to appear, along with the animal name prediction.
     - **Please Note:** Using the provided "animal_database" folder supplied in class and choosing an image from the dataset will take about 2-3 minutes to show the result. Please wait for it and be patient.
   
   - **Running the Testing Process:**
     - User presses the "Run The Testing Data" button.
     - User chooses the Testing Data Folder as prompted.
     - **Important:** You can choose any images from the training set and put them together in a single folder, but NEVER remove them from the Training folder.
     - User chooses the Training Data Folder as prompted.
     - Finding the resulting accuracy for the corresponding Testing and Training data will take several hours.
     - **Progress Monitoring:** The user can monitor the progress in the Command Window of MATLAB. When the progress reaches 100%, the accuracy result will be displayed.
  
   **Please Consider:** Everything works properly, any large delay in processing time is due to the system's computational demands.

## Dependencies:

- MATLAB R2019a or higher.
