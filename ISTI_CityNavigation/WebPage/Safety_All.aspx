<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Safety_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Safety_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".CityClass").hide();

            /// 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "Sf_CityNo";

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
                        getUnderWaterArea();
                        break;
                    case "03":
                        getPM25Quantity();
                        break;
                    case "04":
                        get10KPeopleFireTimesYear();
                        break;
                    case "05":
                        get100KPeopleBurglaryTimes();
                        break;
                    case "06":
                        getBurglaryClearanceRate();
                        break;
                    case "07":
                        get100KPeopleCriminalCaseTimes();
                        break;
                    case "08":
                        getCriminalCaseClearanceRate();
                        break;
                    case "09":
                        get100KPeopleViolentCrimesTimes();
                        break;
                    case "10":
                        getViolentCrimesClearanceRate();
                        break;
                }
            });

            defaultInfo();


            $(document).on("change", "#selType", function () {
                $(".CityClass").hide();
                Page.Option.SortMethod = "+";
                Page.Option.SortName = "Sf_CityNo";
                Safety_All_Array.length = 0;
                switch ($("#selType").val()) {
                    case "01":
                        document.getElementById("SoilArea_tablist").style.display = "";
                        getData();
                        titlePie = "土壤污染控制場址面積";
                        DrawChart(titlePie);
                        break;
                    case "02":
                        document.getElementById("UnderWaterArea_tablist").style.display = "";
                        getUnderWaterArea();
                        titlePie = "地下水受污染使用限制面積";
                        DrawChart(titlePie);
                        break;
                    case "03":
                        document.getElementById("PM25Quantity_tablist").style.display = "";
                        getPM25Quantity();
                        titlePie = "總懸浮微粒排放量";
                        DrawChart(titlePie);
                        break;
                    case "04":
                        document.getElementById("10KPeopleFireTimesYear_tablist").style.display = "";
                        get10KPeopleFireTimesYear();
                        titlePie = "每萬人火災發生次數";
                        DrawChart(titlePie);
                        break;
                    case "05":
                        document.getElementById("100KPeopleBurglaryTimes_tablist").style.display = "";
                        get100KPeopleBurglaryTimes();
                        titlePie = "每十萬人竊盜案發生數";
                        DrawChart(titlePie);
                        break;
                    case "06":
                        document.getElementById("BurglaryClearanceRate_tablist").style.display = "";
                        getBurglaryClearanceRate();
                        titlePie = "竊盜案破獲率";
                        DrawChart(titlePie);
                        break;
                    case "07":
                        document.getElementById("100KPeopleCriminalCaseTimes_tablist").style.display = "";
                        get100KPeopleCriminalCaseTimes();
                        titlePie = "每十萬人刑案發生數";
                        DrawChart(titlePie);
                        break;
                    case "08":
                        document.getElementById("CriminalCaseClearanceRate_tablist").style.display = "";
                        getCriminalCaseClearanceRate();
                        titlePie = "刑案破獲率";
                        DrawChart(titlePie);
                        break;
                    case "09":
                        document.getElementById("100KPeopleViolentCrimesTimes_tablist").style.display = "";
                        get100KPeopleViolentCrimesTimes();
                        titlePie = "每十萬人暴力犯罪發生數";
                        DrawChart(titlePie);
                        break;
                    case "10":
                        document.getElementById("ViolentCrimesClearanceRate_tablist").style.display = "";
                        getViolentCrimesClearanceRate();
                        titlePie = "暴力犯罪破獲率";
                        DrawChart(titlePie);
                        break;
                }
            });


        }); //js end


        var Safety_All_Array = [];
        function defaultInfo() {
            document.getElementById("SoilArea_tablist").style.display = "";
            getData();
            titlePie = "土壤污染控制場址面積";
            DrawChart(titlePie);
        }

        //土壤污染控制場址面積
        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
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
                        $("#SoilArea_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_SoilAreaYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Sf_SoilArea").text().trim()).toFixed(0)) + '㎡' + '</td>';
                                Safety_All_Array.push($(this).children("Sf_SoilArea").text().trim().toString());
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#SoilArea_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //地下水受污染使用限制面積
        function getUnderWaterArea() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
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
                        $("#UnderWaterArea_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_UnderWaterAreaYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Sf_UnderWaterArea").text().trim()).toFixed(0)) + '㎡' + '</td>';
                                Safety_All_Array.push($(this).children("Sf_UnderWaterArea").text().trim().toString());
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#UnderWaterArea_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //總懸浮微粒排放量
        function getPM25Quantity() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
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
                        $("#PM25Quantity_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_PM25QuantityYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Sf_PM25Quantity").text().trim()).toFixed(2)) + '公噸' + '</td>';
                                Safety_All_Array.push(Number($(this).children("Sf_PM25Quantity").text().trim()).toFixed(2));
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#PM25Quantity_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //每萬人火災發生次數
        function get10KPeopleFireTimesYear() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
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
                        $("#10KPeopleFireTimesYear_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_10KPeopleFireTimesYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Sf_10KPeopleFireTimes").text().trim()).toFixed(2)) + '次' + '</td>';
                                Safety_All_Array.push($(this).children("Sf_10KPeopleFireTimes").text().trim().toString());
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#10KPeopleFireTimesYear_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //每十萬人竊盜案發生數
        function get100KPeopleBurglaryTimes() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
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
                        $("#100KPeopleBurglaryTimes_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleBurglaryTimesYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Sf_100KPeopleBurglaryTimes").text().trim()).toFixed(2)) + '件' + '</td>';
                                Safety_All_Array.push($(this).children("Sf_100KPeopleBurglaryTimes").text().trim().toString());
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#100KPeopleBurglaryTimes_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //竊盜案破獲率
        function getBurglaryClearanceRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
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
                        $("#BurglaryClearanceRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_BurglaryClearanceRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Sf_BurglaryClearanceRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Safety_All_Array.push($(this).children("Sf_BurglaryClearanceRate").text().trim().toString());
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#BurglaryClearanceRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //每十萬人刑案發生數
        function get100KPeopleCriminalCaseTimes() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
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
                        $("#100KPeopleCriminalCaseTimes_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleCriminalCaseTimesYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Sf_100KPeopleCriminalCaseTimes").text().trim()).toFixed(2)) + '件' + '</td>';
                                Safety_All_Array.push($(this).children("Sf_100KPeopleCriminalCaseTimes").text().trim().toString());
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#100KPeopleCriminalCaseTimes_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //刑案破獲率
        function getCriminalCaseClearanceRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
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
                        $("#CriminalCaseClearanceRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CriminalCaseClearanceRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Sf_CriminalCaseClearanceRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Safety_All_Array.push($(this).children("Sf_CriminalCaseClearanceRate").text().trim().toString());
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#CriminalCaseClearanceRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //每十萬人暴力犯罪發生數
        function get100KPeopleViolentCrimesTimes() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
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
                        $("#100KPeopleViolentCrimesTimes_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleViolentCrimesTimesYear").text().trim() + '年' + '</td>';
                                var tmpVal = ($.isNumeric($(this).children("Sf_100KPeopleViolentCrimesTimes").text().trim())) ? Number($(this).children("Sf_100KPeopleViolentCrimesTimes").text().trim()).toFixed(2) : 0;
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(tmpVal) + '件' + '</td>';
                                Safety_All_Array.push(tmpVal);
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#100KPeopleViolentCrimesTimes_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //暴力犯罪破獲率
        function getViolentCrimesClearanceRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
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
                        $("#ViolentCrimesClearanceRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_ViolentCrimesClearanceRateYear").text().trim() + '年' + '</td>';
                                var tmpVal = ($.isNumeric($(this).children("Sf_100KPeopleViolentCrimesTimes").text().trim())) ? Number($(this).children("Sf_ViolentCrimesClearanceRate").text().trim()).toFixed(2) : 0;
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(tmpVal) + '%' + '</td>';
                                Safety_All_Array.push(tmpVal);
                                tabstr += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ViolentCrimesClearanceRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }


        function DrawChart(titlePie) {
            $('#stackedcolumn1').highcharts({
                chart: {
                    type: 'pie'
                },
                title: {
                    text: titlePie
                },
                series: [{
                    name: '',
                    colorByPoint: true,
                    data: [
                        {
                            name: '臺北市',
                            y: parseFloat(Safety_All_Array[1])
                        },
                        {
                            name: '新北市',
                            y: parseFloat(Safety_All_Array[0])
                        },
                        {
                            name: '基隆市',
                            y: parseFloat(Safety_All_Array[17])
                        },
                        {
                            name: '桃園市',
                            y: parseFloat(Safety_All_Array[2])
                        },
                        {
                            name: '宜蘭縣',
                            y: parseFloat(Safety_All_Array[6])
                        },
                        {
                            name: '新竹縣',
                            y: parseFloat(Safety_All_Array[7])
                        },
                        {
                            name: '新竹市',
                            y: parseFloat(Safety_All_Array[18])
                        },
                        {
                            name: '苗栗縣',
                            y: parseFloat(Safety_All_Array[8])
                        },
                        {
                            name: '臺中市',
                            y: parseFloat(Safety_All_Array[3])
                        },
                        {
                            name: '彰化縣',
                            y: parseFloat(Safety_All_Array[9])
                        },
                        {
                            name: '南投縣',
                            y: parseFloat(Safety_All_Array[10])
                        },
                        {
                            name: '雲林縣',
                            y: parseFloat(Safety_All_Array[11])
                        },
                        {
                            name: '嘉義縣',
                            y: parseFloat(Safety_All_Array[12])
                        },
                        {
                            name: '嘉義市',
                            y: parseFloat(Safety_All_Array[19])
                        },
                        {
                            name: '臺南市',
                            y: parseFloat(Safety_All_Array[4])
                        },
                        {
                            name: '高雄市',
                            y: parseFloat(Safety_All_Array[5])
                        },
                        {
                            name: '屏東縣',
                            y: parseFloat(Safety_All_Array[13])
                        },
                        {
                            name: '花蓮縣',
                            y: parseFloat(Safety_All_Array[15])
                        },
                        {
                            name: '臺東縣',
                            y: parseFloat(Safety_All_Array[14])
                        },
                        {
                            name: '金門縣',
                            y: parseFloat(Safety_All_Array[20])
                        },
                        {
                            name: '連江縣',
                            y: parseFloat(Safety_All_Array[21])
                        },
                        {
                            name: '澎湖縣',
                            y: parseFloat(Safety_All_Array[16])
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
                <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 智慧安全、治理</div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div style="margin-top: 10px;">
                類別：
        <select id="selType" name="selClass" class="inputex">
            <option value="01">土壤污染控制場址面積</option>
            <option value="02">地下水受污染使用限制面積</option>
            <option value="03">總懸浮微粒排放量</option>
            <option value="04">每萬人火災發生次數</option>
            <option value="05">每十萬人竊盜案發生數</option>
            <option value="06">竊盜案破獲率</option>
            <option value="07">每十萬人刑案發生數</option>
            <option value="08">刑案破獲率</option>
            <option value="09">每十萬人暴力犯罪發生數</option>
            <option value="10">暴力犯罪破獲率</option>
        </select>
            </div>
            <div class="row margin10T ">
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                        <%--土壤污染控制場址面積--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="SoilArea_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_SoilArea">土壤污染控制場址面積</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--地下水受污染使用限制面積--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="UnderWaterArea_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_UnderWaterArea">地下水受污染使用限制面積</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--總懸浮微粒排放量--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="PM25Quantity_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_PM25Quantity">總懸浮微粒排放量</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每萬人火災發生次數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="10KPeopleFireTimesYear_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_10KPeopleFireTimes">每萬人火災發生次數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每十萬人竊盜案發生數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="100KPeopleBurglaryTimes_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_100KPeopleBurglaryTimes">每十萬人竊盜案發生數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--竊盜案破獲率--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="BurglaryClearanceRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_BurglaryClearanceRate">竊盜案破獲率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每十萬人刑案發生數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="100KPeopleCriminalCaseTimes_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_100KPeopleCriminalCaseTimes">每十萬人刑案發生數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--刑案破獲率--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="CriminalCaseClearanceRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_CriminalCaseClearanceRate">刑案破獲率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每十萬人暴力犯罪發生數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="100KPeopleViolentCrimesTimes_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_100KPeopleViolentCrimesTimes">每十萬人暴力犯罪發生數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--暴力犯罪破獲率--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ViolentCrimesClearanceRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Sf_ViolentCrimesClearanceRate">暴力犯罪破獲率</a></th>
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
