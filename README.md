<div id="top"></div>


<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/KamranHussain05/StatsScanner">
    <img src="images/StatScanner-02-logo.png" alt="Logo" width="130" height="130">
  </a>

<h3 align="center">StatScanner</h3>

  <p align="center">
    An app for processing and visualizing your data anywhere!
    <br />
    <a href="https://github.com/KamranHussain05/StatsScanner"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/KamranHussain05/StatsScanner">View Demo</a>
    ·
    <a href="https://github.com/KamranHussain05/StatsScanner/issues">Report Bug</a>
    ·
    <a href="https://github.com/KamranHussain05/StatsScanner/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]]

StatScanner is an IOS app designed to process and visualize any numerical data. You can create predictions, get basic stats, and visualize your data by simply scanning a paper, importing a csv file, or manually entering data. Data can be visualized as bar graphs, pie charts, dot plots, and more in addition to basic statistics. 


<p align="right">(<a href="#top">back to top</a>)</p>

## Compatible with iOS 14.0.1+

## Features

### Data Visualizations
  
<div style="float: left; width: 50%;">
<ul>
<li>Scatter Plot</li>
<li>Line Graph</li>
<li>Bar Chart</li>
<li>Pie Chart</li>
<li>Area Chart</li>
<li>Box Plot</li>
<li>Bubble Chart</li>
<li>Waterfall Plot</li>
</ul>
</div>
<div align="center">
  <a href="https://github.com/KamranHussain05/StatsScanner">
    <img src="images/CrimeAreaChartExample.png" alt="Logo" width="325" height="200">
  </a>
  <a href="https://github.com/KamranHussain05/StatsScanner">
    <img src="images/GamePlay-BarGraphExample.png" alt="Logo" width="325" height="200">
  </a>
  <a href="https://github.com/KamranHussain05/StatsScanner">
    <img src="images/CrimeLineGraph-Example.png" alt="Logo" width="325" height="200">
  </a>
</div align="center">
  
### Statistics

  * Mean, Median, Mode
  * Min, Max, Range
  * Standard Deviation, Standard Error, Mean Absolute Deviation
  
  <div align="center">
<a href="https://github.com/KamranHussain05/StatsScanner">
    <img src="images/Statics-View.png" alt="Logo" width="600" height="400">
  </a>
</div align="center">

### Built With

* [Swift 5.5](https://swift.org/)
* [Swift UI](https://developer.apple.com/xcode/swiftui/)
* [UI Kit](https://developer.apple.com/documentation/uikit)
* [Vision](https://developer.apple.com/documentation/vision)
* [AAChartKit](https://github.com/AAChartModel/AAChartKit-Swift)
* [SpreadsheetView](https://github.com/bannzai/SpreadsheetView)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## How to Use the App

### Importing Data
1. Click the + button in the top right corner and select your data importation method
 - If you selected the "Take Image" or "Import Image" option, make sure your data is in a table format for maximum accuracy
2. After your data has been extracted, you will be navigated to a page containing basic information on your dataset

### Visualizing Data 
1. Open a dataset
2. Click the Graph tab and choose your preferred visualization by scrolling on the carousel
3. You can pinch to zoom, highlight specific data points by tapping, and focus on a specific column

### Edit Data
1. Open a dataset
2. Click the Data tab and tap on a data cell to edit
3. When finished with edits, save your changes with the check mark in the top right corner
 - The pencil icon indicates that you are not in edit mode (toggleable pencil icon has yet to be implemented)
4. Click the green + button or red - button on the edges of your data to add or delete rows and columns

### Export Data
1. Open a dataset
2. Click the Data tab and tap on the export button in the top right corner
3. A CSV copy of your data will be exported to the StatScanner app folder in Files or Documents


_For more examples, please refer to the [Documentation](https://github.com/KamranHussain05/StatsScanner/blob/main/README.md)_

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] Release 1 - Built natively for iOS with local datasets synced across your devices through iCloud
- [ ] Release 2 - New machine learning models that can be trained on imported data with the ability to make inferences
- [ ] Release 3 - Dataset sharing ability and collaboration features
- [ ] Release 4 - Native Android App featuring the same functionality as version 1.0
- [ ] Release 5 - Cross platform sharing between iOS and Android devices

See the [open issues](https://github.com/KamranHussain05/StatsScanner/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement" and leave your email in the issue description. We will contact you with the email provided if your change will be appended.
Don't forget to give the project a star!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the copyright. Contributions also fall under copyright.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Kamran Hussain - [@kamhn123](https://twitter.com/Kamhn123) - kamran.hssn05@gmail.com

Kaleb Kim - [@kaleonthekalb](https://instagram.com/kaleonthekalb) - kalebkim1940@gmail.com

Caden Pun - [@cadenpun](https://instagram.com//cadenpun) - cadenpun@gmail.com

Project Link: [https://github.com/KamranHussain05/StatScanner](https://github.com/KamranHussain05/StatsScanner)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* Logo Designed by [Lagumists](https://www.instagram.com/lagumists/)
* Graphing Utilities Powered by [AAChartKit](https://github.com/AAChartModel/AAChartKit-Swift)
* Data Point View Powered by [SpreadsheetView](https://github.com/bannzai/SpreadsheetView)

Icons
* <a href="https://www.flaticon.com/free-icons/data" title="data icons">Data icons created by Kiranshastry - Flaticon</a>
* <a href="https://www.flaticon.com/free-icons/leadership" title="leadership icons">Leadership icons created by Freepik - Flaticon</a>
* <a href="https://www.flaticon.com/free-icons/statistics" title="statistics icons">Statistics icons created by Andrean Prabowo - Flaticon</a>
* <a href="https://www.flaticon.com/free-icons/pie-chart" title="pie chart icons">Pie chart icons created by Freepik - Flaticon</a>
* <a href="https://www.flaticon.com/free-icons/curve" title="curve icons">Curve icons created by Freepik - Flaticon</a>
* <a href="https://www.flaticon.com/free-icons/stocks" title="stocks icons">Stocks icons created by Freepik - Flaticon</a>

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/KamranHussain05/StatScanner.svg?style=for-the-badge
[contributors-url]: https://github.com/KamranHussain05/StatScanner/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/KamranHussain05/StatScanner.svg?style=for-the-badge
[forks-url]: https://github.com/KamranHussain05/StatScanner/network/members
[stars-shield]: https://img.shields.io/github/stars/KamranHussain05/StatScanner.svg?style=for-the-badge
[stars-url]: https://github.com/KamranHussain05/StatScanner/stargazers
[issues-shield]: https://img.shields.io/github/issues/KamranHussain05/StatScanner.svg?style=for-the-badge
[issues-url]: https://github.com/KamranHussain05/StatScanner/issues
[license-shield]: https://img.shields.io/github/license/KamranHussain05/StatScanner.svg?style=for-the-badge
[license-url]: https://github.com/KamranHussain05/StatScanner/blob/master/LICENSE.txt
[product-screenshot]: images/screenshot.png
