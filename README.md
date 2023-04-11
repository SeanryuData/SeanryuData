### Hi there 👋 Welcome to Sean's Data Analytic Portfolio.
<h1>Project Melbourne Cafe</h1>

<p>This project is aimed at further developing my data analytics skills by exploring the coffee culture in Melbourne. I will analyze data from cafes and restaurants in the city, using a dataset from the Melbourne government website on cafes and restaurants with seating capacity as my primary source of data. I have earned certifications in SQL and Power BI, which I will apply in this project</p>

<h2>Data Source</h2>
<p>The dataset used for this project is called "Café, restaurant, bistro seats." It contains information on cafes and restaurants in Melbourne, including their seating capacity. The dataset has 56987 rows and was last updated 2021.</p>
<ul>
  <li><strong>Data set name:</strong> <em>Café, restaurant, bistro seats
</em></li>
  <li><strong>Link:</strong> <a href="https://data.melbourne.vic.gov.au/explore/dataset/cafes-and-restaurants-with-seating-capacity/information/
">Data set URL</a></li>

<p>
However, the dataset is limited in its scope as it does not provide much information on restaurant/cafe types, revenue, profit, and employee count, which are essential for a comprehensive market analysis. Therefore, it is important to note that some of the assumptions I made during the project may not be suitable for business insight.
</p>
</ul>

<h2>Purpose of the Project</h2>
<p>The main goal of this project is to analyze data on cafes and restaurants in Melbourne and gain insights into the city's coffee culture. I will use my SQL and Power BI skills to perform data analysis and create interactive reports to visualize my findings.
</p>

<h2>Related Certifications Earned</h2>
<ul>
  <li><em>
SQL Challenge - IntermediateSQL Challenge - Intermediate
ModeMode</em></li>
<li><em>Microsoft Certified: Power BI Data Analyst Associate</em></li>
</ul>
<p>Please refer to my linked in page for more details on skills and certificates <a href="https://www.linkedin.com/in/sean-ryu-95745a1a2/details/certifications/">Sean_Ryu Linkedin</a></p>

<h2>Coding Information</h2>
<p>All of my code is contained in a single SQL file, which I have extensively commented on to explain the reasoning behind my choices. For the purpose of demonstrating my proficiency in the language, most, if not all, of the table alterations were made in SQL.
<strong>Link:</strong> <a href=
"https://github.com/SeanryuData/SeanryuData/blob/main/Project.sql
">SQL Codes URL</a>

<strong>Link:</strong> <a href=
"https://github.com/SeanryuData/SeanryuData/raw/main/Project%20version%201.pbix
">PowerBI file for interactive report URL</a>
</p>


<h2>Project Status</h2>
<p>This project is being worked on daily in my free time after work, so please check for updates regularly. As of now, the project is ongoing.
</p>

<h2>Programmes used</h2>
<ul>
  <li><em>
SSMS (MySQL - took more than 1 hour to import data, so changed to SSMS)</em></li>
<li><em>Microsoft Power BI</em></li>
<li><em>Microsoft Onedrive Excel</em></li>
</ul>
<h3>Data Exploration #1</h3>
<p>The original dataset was downloaded in CSV and uploaded to a OneDrive folder for initial exploration. To increase performance inside SQL Server Management Studio (SSMS), unnecessary columns were eliminated, and the file was purposely split into two parts, [Shop] and [Add], for practicing joining inside SQL.</p>
<h3>Data Exploration #2</h3>
<p>After completing the Data ETL process, which involved extracting, transforming, and loading data into Power BI (refer to project.sql), two issues were found within the dataset. The first issue was that some businesses had absurdly high values for the number of seats, and the second issue was that some businesses had a blank regional address value. While most of the transformations were performed inside Power BI using Power Query, SQL was still used for practice. Please refer to line 184 of project.sql.</p>
<h3>Data Exploration #3</h3>
<p>After further modifying the "View" tables inside SQL, the following visuals were created:</p>
<ul>
  <li><em>Census Year slicers and Area buttons for interactions between visuals.</em></li>
  <li><em>Pie charts of seating types and small areas to compare categorical ratios.</em></li>
  <li><em>Map chart using the latitude and longitude values to check the distribution of business locations.</em></li>
</ul>
<img src="https://user-images.githubusercontent.com/130117092/230755809-04cafe08-9676-4c24-84a8-461c3ad58dca.png" alt="Description of the image" width="500" height="300">
<h2>Hypothesis and Insight #1</h2>
<p>During a trip to Melbourne, it was observed that many cafes did not offer spacious seating, and many of the cafes with good Google reviews offered less than ten seats. The hypothesis was that since this is a CBD area, many businesses here decided to downsize to survive. To check if the hypothesis was true, a timed line plot visual was created inside Power BI together with a filtering slicer of different seating ranges.</p>
image

<p>Time line above is for all seating ranges below 50 (50+ are excluded as most of businesses were restaurants which are outside our interest-coffee specialty cafe)
(Melbourne's lockdown period first started in March 2020 and is marked as a red dotted line.)</p>
image

<p>The hypothesis was somewhat correct, as shown in the trend line. The count of cafes with seating range 26+ decreased as of 2020 and 2021. However, it cannot be concluded that the Covid lockdown played a significant role, as the downward trend of the number of cafes for all seating numbers (inclusive of 1-49) started in 2016. Also, if we look at the average seating number of cafes, it reduced from 25.5 to 23.5 from 2005.</p>



<h2>Hypothesis and Insight #2</h2>
<p>Imagine a client has asked for advice on opening a cafe in Melbourne. Using the market analysis above, I have found that the general trend for the average number of seats in cafes is decreasing. Now, I want to determine which suburb would be most suitable (showing an increasing trend) for a client to open up a cafe. To do this, I filtered by seating range of 1-25 and added "Clue_small_area" as a visual to compare regional timeline plots.</p>

![image](https://user-images.githubusercontent.com/130117092/230810802-bae9a3f8-cd08-4cae-8c91-4abb4f058cf7.png)

<p>The above timeline plot shows the trend of Port Melbourne cafes with seating ranges of 1-25. As seen in the figure, the number of coffee shops has been incrementally increasing since 2015, and the average number of seats has remained fairly consistent, while other regions have seen a decline trend.</p>

![image](https://user-images.githubusercontent.com/130117092/230811215-f0ed7d03-74b0-4347-9d53-78c7e764cc4a.png)

![image](https://user-images.githubusercontent.com/130117092/230811444-369967ff-662c-4efc-90fe-d8818793c119.png)

<p>As of 2021, only one cafe in Port Melbourne offers indoor seating only, while the remaining six cafes offer both indoor and outdoor seating.</p>
<h2>Hypothesis and Insight #3</h2>
<p>Is there a relationship between the number of seats and location? Rent and lease prices are increasing towards the CBD area, so there may be more small cafes near the CBD. I will examine this relationship using two variables: "Block_ID" and "Latitude & Longitude."</p>

![image](https://user-images.githubusercontent.com/130117092/230813540-d3b56bcd-3d8d-4652-8818-a7f70cb91eb5.png)

<p>The above figures show scatter plots of the average seating number and summarized seating number versus Block_ID, but I could not find any apparent evidence of a relationship in either the plot or table examination.</p>
image

<p>The above figure shows a scatter plot of the average seating number versus Latitude and Longitude. However, I could not find any signs of a relationship. What I did notice was a large cluster near the longitude of 144.96 and the latitude of -37.82, which is located just above Queen's Bridge street inside the CBD. (I wish I had information on either the revenue or the average number of customers visiting cafes, as that would likely differ the most by location.)</p>
