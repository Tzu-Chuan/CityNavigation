<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Traffic_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Traffic_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".CityClass").hide();

            /// 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "Tra_CityNo";

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
                        getarRoadOutsideParkSpace();
                        break;
                    case "03":
                        getPublicTransportRate();
                        break;
                    case "04":
                        getarParkTime();
                        break;
                    case "05":
                        get10KHaveCarPark();
                        break;
                    case "06":
                        getCarCount();
                        break;
                    case "07":
                        get100HaveCar();
                        break;
                    case "08":
                        get100HaveCarRate();
                        break;
                    case "09":
                        get10KMotoIncidentsNum();
                        break;
                    case "10":
                        get100KNumberOfCasualties();
                        break;
                }
            });

            strTraffic();

            $(document).on("change", "#selType", function () {
                strTraffic();
            });
        }); //js end

        function strTraffic() {
            $(".CityClass").hide();
                Page.Option.SortMethod = "+";
                Page.Option.SortName = "Tra_CityNo";
                Traffic_All_Array.length = 0;
                switch ($("#selType").val()) {
                    case "01":
                        document.getElementById("CarParkSpace_tablist").style.display = "";
                        getData();
                        titlePei = "小汽車路邊停車位";
                        DrawChart(titlePei);
                        break;
                    case "02":
                        document.getElementById("CarRoadOutsideParkSpace_tablist").style.display = "";
                        getarRoadOutsideParkSpace();
                        titlePei = "小汽車路外停車位";
                        DrawChart(titlePei);
                        break;
                    case "03":
                        document.getElementById("PublicTransportRate_table").style.display = "";
                        getPublicTransportRate();
                        titlePei = "通勤學民眾運具次數之公共運具市佔率";
                        DrawChart(titlePei);
                        break;
                    case "04":
                        document.getElementById("CarParkTime_table").style.display = "";
                        getarParkTime();
                        titlePei = "自小客車在居家附近每次尋找停車位時間";
                        DrawChart(titlePei);
                        break;
                    case "05":
                        document.getElementById("10KHaveCarPark_table").style.display = "";
                        get10KHaveCarPark();
                        titlePei = "每萬輛小型車擁有路外及路邊停車位數";
                        DrawChart(titlePei);
                        break;
                    case "06":
                        document.getElementById("CarCount_table").style.display = "";
                        getCarCount();
                        titlePei = "汽車登記數";
                        DrawChart(titlePei);
                        break;
                    case "07":
                        document.getElementById("100HaveCar_table").style.display = "";
                        get100HaveCar();
                        titlePei = "每百人擁有汽車數";
                        DrawChart(titlePei);
                        break;
                    case "08":
                        document.getElementById("100HaveCarRate_table").style.display = "";
                        get100HaveCarRate();
                        titlePei = "每百人擁有汽車數成長率";
                        DrawChart(titlePei);
                        break;
                    case "09":
                        document.getElementById("10KMotoIncidentsNum_table").style.display = "";
                        get10KMotoIncidentsNum();
                        titlePei = "每萬輛機動車肇事數";
                        DrawChart(titlePei);
                        break;
                    case "10":
                        document.getElementById("100KNumberOfCasualties_table").style.display = "";
                        get100KNumberOfCasualties();
                        titlePei = "每十萬人道路交通事故死傷人數";
                        DrawChart(titlePei);
                        break;
                }
        }

        var Traffic_All_Array = [];
        function defaultInfo() {
            document.getElementById("CarParkSpace_tablist").style.display = "";
            getData();
            titlePei = "小汽車路邊及路外停車位";
            DrawChart(titlePei);
        }

        //撈小汽車路邊停車位
        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
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
                        $("#CarParkSpace_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarRoadsidParkSpaceYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Tra_CarRoadsidParkSpace").text().trim()).toFixed(0)) + '個' + '</td>';
                                Traffic_All_Array.push($(this).children("Tra_CarRoadsidParkSpace").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#CarParkSpace_tablist tbody").append(tabstr);
                    }
                }
            })
        }

        //撈小汽車路外停車位
        function getarRoadOutsideParkSpace() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
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
                        $("#CarRoadOutsideParkSpace_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarRoadOutsideParkSpaceYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Tra_CarRoadOutsideParkSpace").text().trim()).toFixed(0)) + '個' + '</td>';
                                Traffic_All_Array.push($(this).children("Tra_CarRoadOutsideParkSpace").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#CarRoadOutsideParkSpace_tablist tbody").append(tabstr);
                    }
                }
            })
        }

        //撈通勤學民眾運具次數之公共運具市佔率
        function getPublicTransportRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
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
                        $("#PublicTransportRate_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_PublicTransportRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Tra_PublicTransportRate").text().trim()).toFixed(1)) + '%' + '</td>';
                                Traffic_All_Array.push($(this).children("Tra_PublicTransportRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PublicTransportRate_table tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //自小客車在居家附近每次尋找停車位時間
        function getarParkTime() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
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
                        $("#CarParkTime_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarParkTimeYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Tra_CarParkTime").text().trim()).toFixed(1)) + '分鐘' + '</td>';
                                Traffic_All_Array.push($(this).children("Tra_CarParkTime").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#CarParkTime_table tbody").append(tabstr);
                    }
                }
            })
        }

        //每萬輛小型車擁有路外及路邊停車位數
        function get10KHaveCarPark() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
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
                        $("#10KHaveCarPark_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_10KHaveCarParkYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Tra_10KHaveCarPark").text().trim()).toFixed(2)) + '位／萬輛' + '</td>';
                                Traffic_All_Array.push($(this).children("Tra_10KHaveCarPark").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#10KHaveCarPark_table tbody").append(tabstr);
                    }
                }
            })
        }

        //汽車登記數
        function getCarCount() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
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
                        $("#CarCount_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarCountYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Tra_CarCount").text().trim()).toFixed(1)) + '輛' + '</td>';
                                Traffic_All_Array.push($(this).children("Tra_CarCount").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#CarCount_table tbody").append(tabstr);
                    }
                }
            })
        }

        //每百人擁有汽車數
        function get100HaveCar() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
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
                        $("#100HaveCar_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100HaveCarYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Tra_100HaveCar").text().trim()).toFixed(1)) + '輛' + '</td>';
                                Traffic_All_Array.push($(this).children("Tra_100HaveCar").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#100HaveCar_table tbody").append(tabstr);
                    }
                }
            })
        }

        //每百人擁有汽車數成長率
        function get100HaveCarRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
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
                        $("#100HaveCarRate_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100HaveCarRateYearDec").text().trim() + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Tra_100HaveCarRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Traffic_All_Array.push($(this).children("Tra_100HaveCarRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#100HaveCarRate_table tbody").append(tabstr);
                    }
                }
            })
        }

        //每萬輛機動車肇事數
        function get10KMotoIncidentsNum() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
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
                        $("#10KMotoIncidentsNum_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_10KMotoIncidentsNumYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Tra_10KMotoIncidentsNum").text().trim()).toFixed(2)) + '次' + '</td>';
                                Traffic_All_Array.push($(this).children("Tra_10KMotoIncidentsNum").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#10KMotoIncidentsNum_table tbody").append(tabstr);
                    }
                }
            })
        }

        //每十萬人道路交通事故死傷人數
        function get100KNumberOfCasualties() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
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
                        $("#100KNumberOfCasualties_table tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100KNumberOfCasualtiesYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Tra_100KNumberOfCasualties").text().trim()).toFixed(2)) + '人' + '</td>';
                                Traffic_All_Array.push($(this).children("Tra_100KNumberOfCasualties").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#100KNumberOfCasualties_table tbody").append(tabstr);
                    }
                }
            })
        }

        function DrawChart(titlePei) {
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
                            y: parseFloat(Traffic_All_Array[1])
                        },
                        {
                            name: '新北市',
                            y: parseFloat(Traffic_All_Array[0])
                        },
                        {
                            name: '基隆市',
                            y: parseFloat(Traffic_All_Array[17])
                        },
                        {
                            name: '桃園市',
                            y: parseFloat(Traffic_All_Array[2])
                        },
                        {
                            name: '宜蘭縣',
                            y: parseFloat(Traffic_All_Array[6])
                        },
                        {
                            name: '新竹縣',
                            y: parseFloat(Traffic_All_Array[7])
                        },
                        {
                            name: '新竹市',
                            y: parseFloat(Traffic_All_Array[18])
                        },
                        {
                            name: '苗栗縣',
                            y: parseFloat(Traffic_All_Array[8])
                        },
                        {
                            name: '臺中市',
                            y: parseFloat(Traffic_All_Array[3])
                        },
                        {
                            name: '彰化縣',
                            y: parseFloat(Traffic_All_Array[9])
                        },
                        {
                            name: '南投縣',
                            y: parseFloat(Traffic_All_Array[10])
                        },
                        {
                            name: '雲林縣',
                            y: parseFloat(Traffic_All_Array[11])
                        },
                        {
                            name: '嘉義縣',
                            y: parseFloat(Traffic_All_Array[12])
                        },
                        {
                            name: '嘉義市',
                            y: parseFloat(Traffic_All_Array[19])
                        },
                        {
                            name: '臺南市',
                            y: parseFloat(Traffic_All_Array[4])
                        },
                        {
                            name: '高雄市',
                            y: parseFloat(Traffic_All_Array[5])
                        },
                        {
                            name: '屏東縣',
                            y: parseFloat(Traffic_All_Array[13])
                        },
                        {
                            name: '花蓮縣',
                            y: parseFloat(Traffic_All_Array[15])
                        },
                        {
                            name: '臺東縣',
                            y: parseFloat(Traffic_All_Array[14])
                        },
                        {
                            name: '金門縣',
                            y: parseFloat(Traffic_All_Array[20])
                        },
                        {
                            name: '連江縣',
                            y: parseFloat(Traffic_All_Array[21])
                        },
                        {
                            name: '澎湖縣',
                            y: parseFloat(Traffic_All_Array[16])
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
                <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 交通</div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div style="margin-top: 10px;">
                類別：
                <select id="selType" name="selClass" class="inputex">
                    <option value="01">小汽車路邊停車位</option>
                    <option value="02">小汽車路外停車位</option>
                    <option value="03">通勤學民眾運具次數之公共運具市佔率</option>
                    <option value="04">自小客車在居家附近每次尋找停車位時間</option>
                    <option value="05">每萬輛小型車擁有路邊停車位數</option>
                    <option value="06">汽車登記數</option>
                    <option value="07">每百人擁有汽車數</option>
                    <option value="08">每百人擁有汽車數成長率</option>
                    <option value="09">每萬輛機動車肇事數</option>
                    <option value="10">每十萬人道路交通事故死傷人數</option>
                </select>
            </div>
            <div class="row margin10T ">
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                        <%--小汽車路邊及路外停車位--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="CarParkSpace_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CarRoadsidParkSpace">小汽車路邊停車位</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--小汽車路外停車位--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="CarRoadOutsideParkSpace_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CarRoadOutsideParkSpace">小汽車路外停車位</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--通勤學民眾運具次數之公共運具市佔率--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="PublicTransportRate_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_PublicTransportRate">通勤學民眾運具次數之公共運具市佔率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--自小客車在居家附近每次尋找停車位時間--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="CarParkTime_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CarParkTime">自小客車在居家附近每次尋找停車位時間</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每萬輛小型車擁有路外及路邊停車位數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="10KHaveCarPark_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_10KHaveCarPark">自小客車在居家附近每次尋找停車位時間</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--汽車登記數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="CarCount_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CarCount">汽車登記數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每百人擁有汽車數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="100HaveCar_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_100HaveCar">每百人擁有汽車數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每百人擁有汽車數成長率--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="100HaveCarRate_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_100HaveCarRate">每百人擁有汽車數成長率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每萬輛機動車肇事數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="10KMotoIncidentsNum_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_10KMotoIncidentsNum">每萬輛機動車肇事數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每十萬人道路交通事故死傷人數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="100KNumberOfCasualties_table" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_100KNumberOfCasualties">每十萬人道路交通事故死傷人數</a></th>
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
