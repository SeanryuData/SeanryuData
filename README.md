### Hi there 👋 Welcome to Sean's Data Analytic Portfolio.
<h1>Project Melbourne Cafe</h1>

<p>This is a project I decided to create for the purpose of gaining experience and utilizing my data analytics skills, which I acquired through various certification programs in SQL and PowerBI.</p>

<h2>Data Source</h2>
<p>I used the following data set as the basis for this project:</p>
<ul>
  <li><strong>Data set name:</strong> <em>Café, restaurant, bistro seats
</em></li>
  <li><strong>Link:</strong> <a href="https://data.melbourne.vic.gov.au/explore/dataset/cafes-and-restaurants-with-seating-capacity/information/
">Data set URL</a></li>
</ul>

<h2>Purpose of the Project</h2>
<p>This is a project I created to apply and gain experience in my data analytics skills, which I learned through certifications in SQL and Power BI.
I chose the cafes and restaurants with seating capacity data set from the Melbourne government website (https://data.melbourne.vic.gov.au/explore/dataset/cafes-and-restaurants-with-seating-capacity/information/) as it aligns with my recent coffee trip to Melbourne. As a coffee enthusiast, I was intrigued by the coffee culture in Melbourne and wanted to find insights to share from the data set. Moreover, I wanted to compare my data analytics findings to my personal experience visiting Melbourne in March 202</p>

<h2>Related Certifications Earned</h2>
<ul>
  <li><em>
SQL Challenge - IntermediateSQL Challenge - Intermediate
ModeMode</em></li>
<li><em>Microsoft Certified: Power BI Data Analyst Associate</em></li>
</ul>
<p>Please refer to my linked in page for more details on skills and certificates <a href="https://www.linkedin.com/in/sean-ryu-95745a1a2/details/certifications/">Sean_Ryu Linkedin</a></p>

<h2>Coding Information</h2>
<p>All of my code is contained in a single SQL file, which I have extensively commented on to explain the reasoning behind my choices. For the purpose of demonstrating my proficiency in the language, most, if not all, of the table alterations were made in SQL.</p>


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

<h3>Data Exploration#1</h3>
<p>
The original data set was downloaded in CSV, uploaded to Onedrive folder for an initial exploration.
Then to increase the performance inside SSMS
eliminated unncessary columns, then to practice joining inside SQL, I purposly split the file into two parts [Shop] and [Add].
</p>

<h3>Data exploration#2</h3>
<p>
After completing the Data ETL - Extract, Transform (refer to project.sql), then loading to Power BI. I found two "Flaws" inside the data set (Refer to below SC:)
 <img src="https://user-images.githubusercontent.com/130117092/230755160-13e4ede2-26f4-477f-8bb2-f5adabb83d79.png" alt="Image description">
I see followings from BI visuals of above.
Some of the Business had ridiculusly high value for Number_Of_Seats.
There are some businesses with Regional Address value of (Blank).
Which I will investigate inside SQL. (While I could investigate and perform most of the transformation inside MS powerBI, using Power Query. I still used SQL as it would be a good practice, please refer from line 184 of project.sql)
</p>


<h3>Data exploration#3</h3>
<p>
After further modifying the "View" tables inside  SQL, I created following visuals.
<ul>
  <li><em>
  (Census Year)Slicers and (Area)buttons for interactions between visuals.
</em></li>
<li><em>
Piecharts of Seating types and Small Area to compare the categorial ratios.
</em></li>
<li><em>
Map chart using the latitude and longitude values to check the distribution of locations of Businesses.
</em></li>
</ul>

<img src="https://user-images.githubusercontent.com/130117092/230755809-04cafe08-9676-4c24-84a8-461c3ad58dca.png" alt="description of the image" width="500" height="300">

<h3>Data Exploration#4</h3>
<p>
During my trip in Melbourne, I found it very interesting to see that not many cafe offered a spacious seats, many of the cafe with good google reviews I visited offered seats less than 10.
My hypothesis was "Since this is a CBD area, so many business here decided to downsize to survive."
To check if the hypothesis above is true, I created timed line plot visual inside power bi together with a filtering slicer of different seating ranges.
</p>

![image](https://user-images.githubusercontent.com/130117092/230772897-64ea75ab-4e21-4f74-8f94-8bb154116374.png)

<p>

</P>

![image](https://user-images.githubusercontent.com/130117092/230772910-a06f0cba-7940-4b63-bb31-31bca68e977f.png)

<p>
Time line above is for all seating ranges below 50 (50+ are excluded as most of businesses were restaurants which is outside of our interest-coffee specialty cafe)
(Melbourne's lockdown period first started on March-2020 and it is marked as red dotted line.)

</P>




![image](https://user-images.githubusercontent.com/130117092/230772945-226b0c01-bdf4-47b0-a96c-d6e5444f966d.png)

![image](https://user-images.githubusercontent.com/130117092/230772955-cf525633-3a26-4dc3-9539-ea84bb2b1f74.png)

<p>
The hypothesis was somewhat correct, as shown in the trend line. Count of cafe w. Seating range 26+ decreased as of 2020 and 2021.
However, we cannot conclude that the Covid lockdown played a major role, as the downward trend of # of cafe for all seating numbers (inclusive of 1~49) started 2016. Also if we look at the average seating # of cafe, it reduced from 25.5 to 23.5 from 2005.

</p>
