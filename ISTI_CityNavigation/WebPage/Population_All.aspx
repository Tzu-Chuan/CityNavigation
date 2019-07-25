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

                switch ($("#selType").val()) {
                    case "01":
                        getData();
                        break;
                    case "02":
                        getPeopleTotalPercent();
                        break;
                    case "03":
                        getArea();
                        break;
                    case "04":
                        getChild();
                        break;
                    case "05":
                        getChildPercent();
                        break;
                    case "06":
                        getTeenager();
                        break;
                    case "07":
                        getTeenagerPercent();
                        break;
                    case "08":
                        getOldMen();
                        break;
                    case "09":
                        getOldMenPercent();
                        break;
                }
            });

            defaultInfo();

            $(document).on("change", "#selType", function () {
                $(".CityClass").hide();
                Page.Option.SortName = "P_CityNo";
                Page.Option.SortMethod = "+";
                Population_All_Array.length = 0;
                switch ($("#selType").val()) {
                case "01":
                    document.getElementById("PeopleTotal_table").style.display = "";
                    getData();
                    titlePei = "年底戶籍總人口數";
                    DrawChart(titlePei);
                    break;
                case "02":
                    document.getElementById("PeopleTotalPercent_table").style.display = "";
                    getPeopleTotalPercent();
                    titlePei = "年底戶籍總人口數成長率";
                    DrawChart(titlePei);
                    break;
                case "03":
                    document.getElementById("Area_table").style.display = "";
                    getArea();
                    titlePei = "土地面積";
                    DrawChart(titlePei);
                    break;
                case "04":
                    document.getElementById("Child_table").style.display = "";
                    getChild();
                    titlePei = "0-14歲幼年人口數";
                    DrawChart(titlePei);
                    break;
                case "05":
                    document.getElementById("ChildPercent_table").style.display = "";
                    getChildPercent();
                    titlePei = "0-14歲幼年人口比例";
                    DrawChart(titlePei);
                    break;
                case "06":
                    document.getElementById("Teenager_table").style.display = "";
                    getTeenager();
                    titlePei = "15-64歲青壯年人口數";
                    DrawChart(titlePei);
                    break;
                case "07":
                    document.getElementById("TeenagerPercent_table").style.display = "";
                    getTeenagerPercent();
                    titlePei = "15-64歲青壯年人口比例";
                    DrawChart(titlePei);
                    break;
                case "08":
                    document.getElementById("OldMen_table").style.display = "";
                    getOldMen();
                    titlePei = "65歲以上老年人口數";
                    DrawChart(titlePei);
                    break;
                case "09":
                    document.getElementById("OldMenPercent_table").style.display = "";
                    getOldMenPercent();
                    titlePei = "65歲以上歲老年人口比例";
                    DrawChart(titlePei);
                    break;
            }
            });
        }); //js end


        var Population_All_Array = [];
        function defaultInfo() {
            document.getElementById("PeopleTotal_table").style.display = "";
                    getData();
                    titlePei = "年底戶籍總人口數";
                    DrawChart(titlePei);
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
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
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
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
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
                        $("#PeopleTotalPercent_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_PeopleTotalPercentYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_PeopleTotalPercent").text().trim()).toFixed(2)) + '%' + '</td>';
                                Population_All_Array.push($(this).children("P_PeopleTotalPercent").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PeopleTotalPercent_table tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
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
                        $("#Area_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_AreaYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_Area").text().trim()).toFixed(2)) + 'k㎡' + '</td>';
                                Population_All_Array.push($(this).children("P_Area").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#Area_table tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
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
                        $("#Child_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_ChildYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_Child").text().trim()).toFixed(0)) + '人' + '</td>';
                                Population_All_Array.push($(this).children("P_Child").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#Child_table tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
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
                        $("#ChildPercent_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_ChildPercentYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_ChildPercent").text().trim()).toFixed(2)) + '%' + '</td>';
                                Population_All_Array.push($(this).children("P_ChildPercent").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ChildPercent_table tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
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
                        $("#Teenager_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_TeenagerYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_Teenager").text().trim()).toFixed(0)) + '人' + '</td>';
                                Population_All_Array.push($(this).children("P_Teenager").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#Teenager_table tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
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
                        $("#TeenagerPercent_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_TeenagerPercentYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_TeenagerPercent").text().trim()).toFixed(2)) + '%' + '</td>';
                                Population_All_Array.push($(this).children("P_TeenagerPercent").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#TeenagerPercent_table tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
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
                        $("#OldMen_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_OldMenYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_OldMen").text().trim()).toFixed(0)) + '人' + '</td>';
                                Population_All_Array.push($(this).children("P_OldMen").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#OldMen_table tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
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
                        $("#OldMenPercent_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_OldMenPercentYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_OldMenPercent").text().trim()).toFixed(2)) + '%' + '</td>';
                                Population_All_Array.push($(this).children("P_OldMenPercent").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#OldMenPercent_table tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
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
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="PeopleTotal_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_PeopleTotal">人口數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--年底戶籍總人口數成長率--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="PeopleTotalPercent_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_PeopleTotalPercent">年底戶籍總人口數成長率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--土地面積--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Area_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" id="P_Area" name="sortbtn" sortname="P_Area">土地面積</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--0-14歲幼年人口數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Child_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_Child">0-14歲幼年人口數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--0-14歲幼年人口比例--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ChildPercent_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_ChildPercent">年底戶籍總人口數成長率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--15-64歲青壯年人口數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Teenager_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_Teenager">15-64歲青壯年人口數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--15-64歲青壯年人口比例--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="TeenagerPercent_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_TeenagerPercent">15-64歲青壯年人口比例</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--65歲以上老年人口數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="OldMen_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_OldMen">65歲以上老年人口數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--65歲以上歲老年人口比例--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="OldMenPercent_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_OldMenPercent">65歲以上歲老年人口比例</a></th>
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
