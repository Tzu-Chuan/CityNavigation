<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Education_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Education_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".CityClass").hide();

            /// 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "Edu_CityNo";

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
                        get15upJSDownRate();
                        break;
                    case "03":
                        get15upHSRate();
                        break;
                    case "04":
                        get15upUSUpRate();
                        break;
                    case "05":
                        getESStudentDropOutRate();
                        break;
                    case "06":
                        getJSStudentDropOutRate();
                        break;
                    case "07":
                        getJSStudents();
                        break;
                    case "08":
                        getESToHSIdigenous();
                        break;
                    case "09":
                        getESToHSIndigenousRate();
                        break;
                    case "10":
                        getESJSNewInhabitants();
                        break;
                    case "11":
                        getESToJSNewInhabitantsRate();
                        break;
                    case "12":
                        getESJSTeachers();
                        break;
                    case "13":
                        getESJSTeachersOfStudentRate();
                        break;
                    case "14":
                        getBudget();
                        break;
                    case "15":
                        getBudgetUpRate();
                        break;
                    case "16":
                        getESToHSAvgBudget();
                        break;
                    case "17":
                        getESJSPCNum();
                        break;
                    case "18":
                        getESJSAvgPCNum();
                        break;
                    default:
                        getData();
                        break;
                }
            });

            defaultInfo();

            $(document).on("change", "#selType", function () {
                $(".CityClass").hide();
                Page.Option.SortMethod = "+";
                Page.Option.SortName = "Edu_CityNo";
                Education_All_Array.length = 0;
                switch ($("#selType").val()) {
                    case "01":
                        document.getElementById("ESStudents_tablist").style.display = "";
                        getData();
                        titlePei = "國小總學生數";
                        DrawChart(titlePei);
                        break;
                    case "02":
                        document.getElementById("15upJSDownRate_tablist").style.display = "";
                        get15upJSDownRate();
                        titlePei = "15歲以上民間人口之教育程度結構-國中及以下";
                        DrawChart(titlePei);
                        break;
                    case "03":
                        document.getElementById("15upHSRate_tablist").style.display = "";
                        get15upHSRate();
                        titlePei = "15歲以上民間人口之教育程度結構-高中(職)";
                        DrawChart(titlePei);
                        break;
                    case "04":
                        document.getElementById("15upUSUpRate_tablist").style.display = "";
                        get15upUSUpRate();
                        titlePei = "15歲以上民間人口之教育程度結構-大專及以上";
                        DrawChart(titlePei);
                        break;
                    case "05":
                        document.getElementById("ESStudentDropOutRate_tablist").style.display = "";
                        getESStudentDropOutRate();
                        titlePei = "國小學生輟學率";
                        DrawChart(titlePei);
                        break;
                    case "06":
                        document.getElementById("JSStudentDropOutRate_tablist").style.display = "";
                        getJSStudentDropOutRate();
                        titlePei = "國中學生輟學率";
                        DrawChart(titlePei);
                        break;
                    case "07":
                        document.getElementById("JSStudents_tablist").style.display = "";
                        getJSStudents();
                        titlePei = "國中總學生數";
                        DrawChart(titlePei);
                        break;
                    case "08":
                        document.getElementById("ESToHSIdigenous_tablist").style.display = "";
                        getESToHSIdigenous();
                        titlePei = "國小-高中(職)原住民學生數";
                        DrawChart(titlePei);
                        break;
                    case "09":
                        document.getElementById("ESToHSIndigenousRate_tablist").style.display = "";
                        getESToHSIndigenousRate();
                        titlePei = "國小-高中(職)原住民學生數比例";
                        DrawChart(titlePei);
                        break;
                    case "10":
                        document.getElementById("ESJSNewInhabitants_tablist").style.display = "";
                        getESJSNewInhabitants();
                        titlePei = "國中小新住民人數";
                        DrawChart(titlePei);
                        break;
                    case "11":
                        document.getElementById("ESToJSNewInhabitantsRate_tablist").style.display = "";
                        getESToJSNewInhabitantsRate();
                        titlePei = "國中小新住民學生比例";
                        DrawChart(titlePei);
                        break;
                    case "12":
                        document.getElementById("ESJSTeachers_tablist").style.display = "";
                        getESJSTeachers();
                        titlePei = "國中小教師數";
                        DrawChart(titlePei);
                        break;
                    case "13":
                        document.getElementById("ESJSTeachersOfStudentRate_tablist").style.display = "";
                        getESJSTeachersOfStudentRate();
                        titlePei = "國中小生師比(平均每位教師教導學生數)";
                        DrawChart(titlePei);
                        break;
                    case "14":
                        document.getElementById("Budget_tablist").style.display = "";
                        getBudget();
                        titlePei = "教育預算";
                        DrawChart(titlePei);
                        break;
                    case "15":
                        document.getElementById("BudgetUpRate_tablist").style.display = "";
                        getBudgetUpRate();
                        titlePei = "教育預算成長率";
                        DrawChart(titlePei);
                        break;
                    case "16":
                        document.getElementById("ESToHSAvgBudget_tablist").style.display = "";
                        getESToHSAvgBudget();
                        titlePei = "國小-高中(職)平均每人教育預算";
                        DrawChart(titlePei);
                        break;
                    case "17":
                        document.getElementById("ESJSPCNum_tablist").style.display = "";
                        getESJSPCNum();
                        titlePei = "國中小教學電腦數";
                        DrawChart(titlePei);
                        break;
                    case "18":
                        document.getElementById("ESJSAvgPCNum_tablist").style.display = "";
                        getESJSAvgPCNum();
                        titlePei = "國中小平均每人教學電腦數";
                        DrawChart(titlePei);
                        break;
                    default:
                        document.getElementById("ESStudents_tablist").style.display = "";
                        getData();
                        titlePei = "國小總學生數";
                        DrawChart(titlePei);
                        break;
                }
            });

        }); //js end


        var Education_All_Array = [];
        function defaultInfo() {
            document.getElementById("ESStudents_tablist").style.display = "";
            getData();
            titlePei = "國小總學生數";
            DrawChart(titlePei);
        }
        //國小總學生數
        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#ESStudents_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESStudentsYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_ESStudents").text().trim()).toFixed(0)) + '人' + '</td>';
                                Education_All_Array.push($(this).children("Edu_ESStudents").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ESStudents_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //15歲以上民間人口之教育程度結構-國中及以下
        function get15upJSDownRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#15upJSDownRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upJSDownRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_15upJSDownRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Education_All_Array.push($(this).children("Edu_15upJSDownRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#15upJSDownRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //15歲以上民間人口之教育程度結構-高中(職)
        function get15upHSRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#15upHSRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upHSRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_15upHSRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Education_All_Array.push($(this).children("Edu_15upHSRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#15upHSRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //15歲以上民間人口之教育程度結構-大專及以上
        function get15upUSUpRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#15upUSUpRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upUSUpRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_15upUSUpRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Education_All_Array.push($(this).children("Edu_15upUSUpRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#15upUSUpRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國小學生輟學率
        function getESStudentDropOutRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#ESStudentDropOutRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESStudentDropOutRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_ESStudentDropOutRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Education_All_Array.push($(this).children("Edu_ESStudentDropOutRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ESStudentDropOutRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國中學生輟學率
        function getJSStudentDropOutRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#JSStudentDropOutRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_JSStudentDropOutRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_JSStudentDropOutRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Education_All_Array.push($(this).children("Edu_JSStudentDropOutRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#JSStudentDropOutRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國中總學生數
        function getJSStudents() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#JSStudents_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_JSStudentsYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_JSStudents").text().trim()).toFixed(0)) + '人' + '</td>';
                                Education_All_Array.push($(this).children("Edu_JSStudents").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#JSStudents_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國小-高中(職)原住民學生數
        function getESToHSIdigenous() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#ESToHSIdigenous_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSIndigenousYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_ESToHSIdigenous").text().trim()).toFixed(0)) + '人' + '</td>';
                                Education_All_Array.push($(this).children("Edu_ESToHSIdigenous").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ESToHSIdigenous_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國小-高中(職)原住民學生數比例
        function getESToHSIndigenousRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#ESToHSIndigenousRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSIndigenousRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_ESToHSIndigenousRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Education_All_Array.push($(this).children("Edu_ESToHSIndigenousRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ESToHSIndigenousRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國中小新住民人數
        function getESJSNewInhabitants() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#ESJSNewInhabitants_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSNewInhabitantsYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_ESJSNewInhabitants").text().trim()).toFixed(0)) + '人' + '</td>';
                                Education_All_Array.push($(this).children("Edu_ESJSNewInhabitants").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ESJSNewInhabitants_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國中小新住民學生比例
        function getESToJSNewInhabitantsRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#ESToJSNewInhabitantsRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSNewInhabitantsRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_ESToJSNewInhabitantsRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Education_All_Array.push($(this).children("Edu_ESToJSNewInhabitantsRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ESToJSNewInhabitantsRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國中小教師數
        function getESJSTeachers() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#ESJSTeachers_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSTeachersYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_ESJSTeachers").text().trim()).toFixed(0)) + '人' + '</td>';
                                Education_All_Array.push($(this).children("Edu_ESJSTeachers").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ESJSTeachers_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國中小生師比(平均每位教師教導學生數)
        function getESJSTeachersOfStudentRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#ESJSTeachersOfStudentRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSTeachersOfStudentRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_ESJSTeachersOfStudentRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Education_All_Array.push($(this).children("Edu_ESJSTeachersOfStudentRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ESJSTeachersOfStudentRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //教育預算
        function getBudget() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#Budget_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_BudgetYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_Budget").text().trim()).toFixed(2)) + '千元' + '</td>';
                                Education_All_Array.push($(this).children("Edu_Budget").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#Budget_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //教育預算成長率
        function getBudgetUpRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#BudgetUpRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_BudgetUpRateYearDesc").text().trim() + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_BudgetUpRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Education_All_Array.push($.FormatThousandGroup(Number($(this).children("Edu_BudgetUpRate").text().trim()).toFixed(2)));
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#BudgetUpRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國小-高中(職)平均每人教育預算
        function getESToHSAvgBudget() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#ESToHSAvgBudget_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSAvgBudgetYear").text().trim() + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_ESToHSAvgBudget").text().trim()).toFixed(0)) + '千元' + '</td>';
                                Education_All_Array.push($.FormatThousandGroup(Number($(this).children("Edu_ESToHSAvgBudget").text().trim()).toFixed(0)));
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ESToHSAvgBudget_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國中小教學電腦數
        function getESJSPCNum() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#ESJSPCNum_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSPCNumYear").text().trim() + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_ESJSPCNum").text().trim()).toFixed(0)) + '台' + '</td>';
                                Education_All_Array.push($(this).children("Edu_ESJSPCNum").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ESJSPCNum_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //國中小教學電腦數
        function getESJSAvgPCNum() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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
                        $("#ESJSAvgPCNum_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSAvgPCNumYear").text().trim() + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Edu_ESJSAvgPCNum").text().trim()).toFixed(2)) + '台' + '</td>';
                                Education_All_Array.push($(this).children("Edu_ESJSAvgPCNum").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ESJSAvgPCNum_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }


        //hightchart
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
                            y: parseFloat(Education_All_Array[1])
                        },
                        {
                            name: '新北市',
                            y: parseFloat(Education_All_Array[0])
                        },
                        {
                            name: '基隆市',
                            y: parseFloat(Education_All_Array[17])
                        },
                        {
                            name: '桃園市',
                            y: parseFloat(Education_All_Array[2])
                        },
                        {
                            name: '宜蘭縣',
                            y: parseFloat(Education_All_Array[6])
                        },
                        {
                            name: '新竹縣',
                            y: parseFloat(Education_All_Array[7])
                        },
                        {
                            name: '新竹市',
                            y: parseFloat(Education_All_Array[18])
                        },
                        {
                            name: '苗栗縣',
                            y: parseFloat(Education_All_Array[8])
                        },
                        {
                            name: '臺中市',
                            y: parseFloat(Education_All_Array[3])
                        },
                        {
                            name: '彰化縣',
                            y: parseFloat(Education_All_Array[9])
                        },
                        {
                            name: '南投縣',
                            y: parseFloat(Education_All_Array[10])
                        },
                        {
                            name: '雲林縣',
                            y: parseFloat(Education_All_Array[11])
                        },
                        {
                            name: '嘉義縣',
                            y: parseFloat(Education_All_Array[12])
                        },
                        {
                            name: '嘉義市',
                            y: parseFloat(Education_All_Array[19])
                        },
                        {
                            name: '臺南市',
                            y: parseFloat(Education_All_Array[4])
                        },
                        {
                            name: '高雄市',
                            y: parseFloat(Education_All_Array[5])
                        },
                        {
                            name: '屏東縣',
                            y: parseFloat(Education_All_Array[13])
                        },
                        {
                            name: '花蓮縣',
                            y: parseFloat(Education_All_Array[15])
                        },
                        {
                            name: '臺東縣',
                            y: parseFloat(Education_All_Array[14])
                        },
                        {
                            name: '金門縣',
                            y: parseFloat(Education_All_Array[20])
                        },
                        {
                            name: '連江縣',
                            y: parseFloat(Education_All_Array[21])
                        },
                        {
                            name: '澎湖縣',
                            y: parseFloat(Education_All_Array[16])
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
                <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 教育</div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div style="margin-top: 10px;">
                類別：
        <select id="selType" name="selClass" class="inputex">
            <option value="01">國小總學生數</option>
            <option value="02">15歲以上民間人口之教育程度結構-國中及以下</option>
            <option value="03">15歲以上民間人口之教育程度結構-高中(職)</option>
            <option value="04">15歲以上民間人口之教育程度結構-大專及以上</option>
            <option value="05">國小學生輟學率</option>
            <option value="06">國中學生輟學率</option>
            <option value="07">國中總學生數</option>
            <option value="08">國小-高中(職)原住民學生數</option>
            <option value="09">國小-高中(職)原住民學生數比例</option>
            <option value="10">國中小新住民人數</option>
            <option value="11">國中小新住民學生比例</option>
            <option value="12">國中小教師數</option>
            <option value="13">國中小生師比(平均每位教師教導學生數)</option>
            <option value="14">教育預算</option>
            <option value="15">教育預算成長率</option>
            <option value="16">國小-高中(職)平均每人教育預算</option>
            <option value="17">國中小教學電腦數</option>
            <option value="18">國中小平均每人教學電腦數</option>
        </select>
            </div>
            <div class="row margin10T ">
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                        <%--國小總學生數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ESStudents_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_ESStudents">國小總學生數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--15歲以上民間人口之教育程度結構-國中及以下--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="15upJSDownRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_15upJSDownRate">15歲以上民間人口之教育程度結構-國中及以下</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--15歲以上民間人口之教育程度結構-高中(職)--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="15upHSRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_15upHSRate">15歲以上民間人口之教育程度結構-高中(職)</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--15歲以上民間人口之教育程度結構-大專及以上--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="15upUSUpRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_15upUSUpRate">15歲以上民間人口之教育程度結構-大專及以上</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國小學生輟學率--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ESStudentDropOutRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_ESStudentDropOutRate">國小學生輟學率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國中學生輟學率--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="JSStudentDropOutRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_JSStudentDropOutRate">國中學生輟學率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國中總學生數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="JSStudents_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_JSStudents">國中總學生數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國小-高中(職)原住民學生數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ESToHSIdigenous_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_ESToHSIdigenous">國小-高中(職)原住民學生數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國小-高中(職)原住民學生數比例--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ESToHSIndigenousRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_ESToHSIndigenousRate">國小-高中(職)原住民學生數比例</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國中小新住民人數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ESJSNewInhabitants_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_ESJSNewInhabitants">國中小新住民人數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國中小新住民學生比例--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ESToJSNewInhabitantsRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_ESToJSNewInhabitantsRate">國中小新住民學生比例</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國中小教師數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ESJSTeachers_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_ESJSTeachers">國中小教師數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國中小生師比(平均每位教師教導學生數)--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ESJSTeachersOfStudentRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_ESJSTeachersOfStudentRate">國中小生師比(平均每位教師教導學生數)</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--教育預算--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Budget_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_Budget">教育預算</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--教育預算成長率--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="BudgetUpRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_BudgetUpRate">教育預算成長率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國小-高中(職)平均每人教育預算--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ESToHSAvgBudget_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_ESToHSAvgBudget">教育預算成長率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國中小教學電腦數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ESJSPCNum_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_ESJSPCNum">國中小教學電腦數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--國中小平均每人教學電腦數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ESJSAvgPCNum_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_ESJSAvgPCNum">國中小平均每人教學電腦數</a></th>
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
