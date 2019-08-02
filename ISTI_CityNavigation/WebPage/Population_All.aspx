<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Population_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Population_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        $(document).ready(function () {
            $(".CityClass").hide();
            /// 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "P_CityNo";

            ///Highcharts千分位
            Highcharts.setOptions({
                lang: {
                    thousandsSep: ','
                }
            });

            /// 表頭排序
            $(document).on("click", "a[name='sortbtn']", function () {
                $("a[name='sortbtn']").removeClass("asc desc")
                if (Page.Option.SortName != $(this).attr("sortname")) {
                    Page.Option.SortMethod = "-";
                }
                Page.Option.SortName = $(this).attr("sortname");
                if (Page.Option.SortMethod == "-") {
                    Page.Option.SortMethod = "+";
                    $(this).addClass('asc');
                }
                else {
                    Page.Option.SortMethod = "-";
                    $(this).addClass('desc');
                }
                PopulationClass();
            });

            getheadTitle();
            PopulationClass();
            titlePei = "年底戶籍總人口數";
            DrawChart(titlePei);

            $(document).on("change", "#selType", function () {
                Population_All_Array.length = 0;
                getheadTitle();
                PopulationClass();
                switch ($("#selType").val()) {
                    case "01":
                        titlePei = "年底戶籍總人口數";
                        DrawChart(titlePei);
                        break;
                    case "02":
                        titlePei = "年底戶籍總人口數成長率";
                        DrawChart(titlePei);
                        break;
                    case "03":
                        titlePei = "土地面積";
                        DrawChart(titlePei);
                        break;
                    case "04":
                        titlePei = "0-14歲幼年人口數";
                        DrawChart(titlePei);
                        break;
                    case "05":
                        titlePei = "0-14歲幼年人口比例";
                        DrawChart(titlePei);
                        break;
                    case "06":
                        titlePei = "15-64歲青壯年人口數";
                        DrawChart(titlePei);
                        break;
                    case "07":
                        titlePei = "15-64歲青壯年人口比例";
                        DrawChart(titlePei);
                        break;
                    case "08":
                        titlePei = "65歲以上老年人口數";
                        DrawChart(titlePei);
                        break;
                    case "09":
                        titlePei = "65歲以上歲老年人口比例";
                        DrawChart(titlePei);
                        break;
                }
                    
            });
        }); //js end


        var Population_All_Array = [];

        function getheadTitle() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/AllCityKeyTable.aspx",
                data: {
                    K_Code: "Population",
                    K_ItemNo: $("#selType").val(),
                    Token: $("#InfoToken").val()
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#test").empty();
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                $("#test").append('<a href="javascript:void(0);" name="sortbtn" sortname="">' + $("K_Word", data).text().trim() + '</a>');

                                getData();
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                    }
                }
            })
        }

        function PopulationClass() {
            switch ($("#selType").val()) {
                case "01":
                    sortnameStr = "P_PeopleTotal";
                    $("a").attr("sortname", sortnameStr);
                    getData();
                    break;
                case "02":
                    sortnameStr = "P_PeopleTotalPercent";
                    $("a").attr("sortname", sortnameStr);
                    getPeopleTotalPercent();
                    break;
                case "03":
                    sortnameStr = "P_Area";
                    $("a").attr("sortname", sortnameStr);
                    getArea();
                    break;
                case "04":
                    sortnameStr = "P_Child";
                    $("a").attr("sortname", sortnameStr);
                    getChild();
                    break;
                case "05":
                    sortnameStr = "P_ChildPercent";
                    $("a").attr("sortname", sortnameStr);
                    getChildPercent();
                    break;
                case "06":
                    sortnameStr = "P_Teenager";
                    $("a").attr("sortname", sortnameStr);
                    getTeenager();
                    break;
                case "07":
                    sortnameStr = "P_TeenagerPercent";
                    $("a").attr("sortname", sortnameStr);
                    getTeenagerPercent();
                    break;
                case "08":
                    sortnameStr = "P_OldMen";
                    $("a").attr("sortname", sortnameStr);
                    getOldMen();
                    break;
                case "09":
                    sortnameStr = "P_OldMenPercent";
                    $("a").attr("sortname", sortnameStr);
                    getOldMenPercent();
                    break;
            }
        }


        //撈總人口列表
        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: "All",
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod,
                    Token: $("#InfoToken").val()
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#PeopleTotal_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_TotalYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_PeopleTotal").text().trim()).toFixed(0)) + '人' + '</td>';
                                Population_All_Array.push($(this).children("P_PeopleTotal").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PeopleTotal_table tbody").append(tabstr);
                    }
                }
            })
        }

        //撈總人口數成長率
        function getPeopleTotalPercent() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: "All",
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod,
                    Token: $("#InfoToken").val()
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#PeopleTotal_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_PeopleTotalPercentYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_PeopleTotalPercent").text().trim()).toFixed(2)) + '%' + '</td>';
                                Population_All_Array.push($(this).children("P_PeopleTotalPercent").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PeopleTotal_table tbody").append(tabstr);
                    }
                }
            })
        }

        //撈土地面積
        function getArea() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: "All",
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod,
                    Token: $("#InfoToken").val()
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#PeopleTotal_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_AreaYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_Area").text().trim()).toFixed(2)) + 'k㎡' + '</td>';
                                Population_All_Array.push($(this).children("P_Area").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PeopleTotal_table tbody").append(tabstr);
                    }
                }
            })
        }

        //撈0-14歲幼年人口數
        function getChild() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: "All",
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod,
                    Token: $("#InfoToken").val()
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#PeopleTotal_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_ChildYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_Child").text().trim()).toFixed(0)) + '人' + '</td>';
                                Population_All_Array.push($(this).children("P_Child").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PeopleTotal_table tbody").append(tabstr);
                    }
                }
            })
        }

        //撈0-14歲幼年人口數比例
        function getChildPercent() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: "All",
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod,
                    Token: $("#InfoToken").val()
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#PeopleTotal_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_ChildPercentYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_ChildPercent").text().trim()).toFixed(2)) + '%' + '</td>';
                                Population_All_Array.push($(this).children("P_ChildPercent").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PeopleTotal_table tbody").append(tabstr);
                    }
                }
            })
        }

        //撈15-64歲青壯年人口數
        function getTeenager() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: "All",
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod,
                    Token: $("#InfoToken").val()
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#PeopleTotal_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_TeenagerYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_Teenager").text().trim()).toFixed(0)) + '人' + '</td>';
                                Population_All_Array.push($(this).children("P_Teenager").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PeopleTotal_table tbody").append(tabstr);
                    }
                }
            })
        }
        
        //撈15-64歲青壯年人口數比例
        function getTeenagerPercent() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: "All",
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod,
                    Token: $("#InfoToken").val()
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#PeopleTotal_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_TeenagerPercentYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_TeenagerPercent").text().trim()).toFixed(2)) + '%' + '</td>';
                                Population_All_Array.push($(this).children("P_TeenagerPercent").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PeopleTotal_table tbody").append(tabstr);
                    }
                }
            })
        }

        //撈65歲以上老年人口數
        function getOldMen() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: "All",
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod,
                    Token: $("#InfoToken").val()
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#PeopleTotal_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_OldMenYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_OldMen").text().trim()).toFixed(0)) + '人' + '</td>';
                                Population_All_Array.push($(this).children("P_OldMen").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PeopleTotal_table tbody").append(tabstr);
                    }
                }
            })
        }
        
        //撈65歲以上老年人口數比例
        function getOldMenPercent() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: "All",
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod,
                    Token: $("#InfoToken").val()
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#PeopleTotal_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_OldMenPercentYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_OldMenPercent").text().trim()).toFixed(2)) + '%' + '</td>';
                                Population_All_Array.push($(this).children("P_OldMenPercent").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PeopleTotal_table tbody").append(tabstr);
                    }
                }
            })
        }

        //hightchart
        function DrawChart(titlePei) {
            //圓餅圖
            $('#stackedcolumn1').highcharts({
                chart: {
                    type: 'pie'
                },
                title: {
                    text: titlePei
                },
                series: [{
                    name: '',
                    colorByPoint: true,
                    data: [
                        {
                            name: '臺北市',
                            y: parseFloat(Population_All_Array[1])
                        },
                        {
                            name: '新北市',
                            y: parseFloat(Population_All_Array[0])
                        },
                        {
                            name: '基隆市',
                            y: parseFloat(Population_All_Array[17])
                        },
                        {
                            name: '桃園市',
                            y: parseFloat(Population_All_Array[2])
                        },
                        {
                            name: '宜蘭縣',
                            y: parseFloat(Population_All_Array[6])
                        },
                        {
                            name: '新竹縣',
                            y: parseFloat(Population_All_Array[7])
                        },
                        {
                            name: '新竹市',
                            y: parseFloat(Population_All_Array[18])
                        },
                        {
                            name: '苗栗縣',
                            y: parseFloat(Population_All_Array[8])
                        },
                        {
                            name: '臺中市',
                            y: parseFloat(Population_All_Array[3])
                        },
                        {
                            name: '彰化縣',
                            y: parseFloat(Population_All_Array[9])
                        },
                        {
                            name: '南投縣',
                            y: parseFloat(Population_All_Array[10])
                        },
                        {
                            name: '雲林縣',
                            y: parseFloat(Population_All_Array[11])
                        },
                        {
                            name: '嘉義縣',
                            y: parseFloat(Population_All_Array[12])
                        },
                        {
                            name: '嘉義市',
                            y: parseFloat(Population_All_Array[19])
                        },
                        {
                            name: '臺南市',
                            y: parseFloat(Population_All_Array[4])
                        },
                        {
                            name: '高雄市',
                            y: parseFloat(Population_All_Array[5])
                        },
                        {
                            name: '屏東縣',
                            y: parseFloat(Population_All_Array[13])
                        },
                        {
                            name: '花蓮縣',
                            y: parseFloat(Population_All_Array[15])
                        },
                        {
                            name: '臺東縣',
                            y: parseFloat(Population_All_Array[14])
                        },
                        {
                            name: '金門縣',
                            y: parseFloat(Population_All_Array[20])
                        },
                        {
                            name: '連江縣',
                            y: parseFloat(Population_All_Array[21])
                        },
                        {
                            name: '澎湖縣',
                            y: parseFloat(Population_All_Array[16])
                        },
                    ]
                }]
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="tmpGuid" />
    <div class="WrapperBody" id="WrapperBody">
        <div class="container margin15T" id="ContentWrapper">
            <div class="twocol titleLineA">
                <div class="left"><span class="font-size4">全國資料</span></div>
                <!-- left -->
                <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 土地人口</div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div style="margin-top: 10px;">
                類別：
                <select id="selType" name="selClass" class="inputex">
                    <option value="01">年底戶籍總人口數</option>
                    <option value="02">年底戶籍總人口數成長率</option>
                    <option value="03">土地面積</option>
                    <option value="04">0-14歲幼年人口數</option>
                    <option value="05">0-14歲幼年人口比例</option>
                    <option value="06">15-64歲青壯年人口數</option>
                    <option value="07">15-64歲青壯年人口比例</option>
                    <option value="08">65歲以上老年人口數</option>
                    <option value="09">65歲以上歲老年人口比例</option>
                </select>
            </div>
            <div class="row margin10T">
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                        <%--年底戶籍總人口數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="PeopleTotal_table" <%--class="CityClass"--%>>
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;" id="test"></th>

                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <!-- col -->
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div id="stackedcolumn1" class="maxWithA"></div>
                </div>
                <!-- col -->
            </div>
            <!-- row -->
        </div>
    </div>
    <!-- WrapperBody -->
</asp:Content>
