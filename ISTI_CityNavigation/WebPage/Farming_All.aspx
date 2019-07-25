<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Farming_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Farming_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".CityClass").hide();

            /// 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "Fa_CityNo";

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
                        getFarmingLoss();
                        break;
                    case "03":
                        getAnimalLoss();
                        break;
                    case "04":
                        getForestLoss();
                        break;
                    case "05":
                        getFAllLoss();
                        break;
                    case "06":
                        getFacilityLoss();
                        break;
                    case "07":
                        getFarmingOutputValue();
                        break;
                    case "08":
                        getFarmingOutputRate();
                        break;
                    case "09":
                        getFarmer();
                        break;
                    case "10":
                        getFarmEmploymentOutputValue();
                        break;
                }
            });

            defaultInfo();

            $(document).on("change", "#selType", function () {
                $(".CityClass").hide();
                Page.Option.SortMethod = "+";
                Page.Option.SortName = "Fa_CityNo";
                Farming_All_Array.length = 0;
                switch ($("#selType").val()) {
                    case "01":
                        document.getElementById("FishLoss_tablist").style.display = "";
                        getData();
                        titlePei = "臺閩地區農業天然災害產物損失";
                        DrawChart(titlePei);
                        break;
                    case "02":
                        document.getElementById("FarmingLoss_tablist").style.display = "";
                        getFarmingLoss();
                        titlePei = "臺閩地區農業天然災害產物損失";
                        DrawChart(titlePei);
                        break;
                    case "03":
                        document.getElementById("AnimalLoss_tablist").style.display = "";
                        getAnimalLoss();
                        titlePei = "天然災害畜牧業產物損失";
                        DrawChart(titlePei);
                        break;
                    case "04":
                        document.getElementById("ForestLoss_tablist").style.display = "";
                        getForestLoss();
                        titlePei = "臺閩地區林業天然災害產物損失";
                        DrawChart(titlePei);
                        break;
                    case "05":
                        document.getElementById("AllLoss_tablist").style.display = "";
                        getFAllLoss();
                        titlePei = "農林漁牧天然災害產物損失";
                        DrawChart(titlePei);
                        break;
                    case "06":
                        document.getElementById("FacilityLoss_tablist").style.display = "";
                        getFacilityLoss();
                        titlePei = "農林漁牧天然災害設施(備)損失";
                        DrawChart(titlePei);
                        break;
                    case "07":
                        document.getElementById("FarmingOutputValue_tablist").style.display = "";
                        getFarmingOutputValue();
                        titlePei = "農業產值";
                        DrawChart(titlePei);
                        break;
                    case "08":
                        document.getElementById("FarmingOutputRate_tablist").style.display = "";
                        getFarmingOutputRate();
                        titlePei = "農業產值成長率";
                        DrawChart(titlePei);
                        break;
                    case "09":
                        document.getElementById("Farmer_tablist").style.display = "";
                        getFarmer();
                        titlePei = "農戶人口數";
                        DrawChart(titlePei);
                        break;
                    case "10":
                        document.getElementById("FarmEmploymentOutputValue_tablist").style.display = "";
                        getFarmEmploymentOutputValue();
                        titlePei = "平均農業從業人口產值";
                        DrawChart(titlePei);
                        break;
                }
            });
        }); //js end


        var Farming_All_Array = [];
        function defaultInfo() {
            document.getElementById("FishLoss_tablist").style.display = "";
            getData();
            titlePei = "臺閩地區農業天然災害產物損失";
            DrawChart(titlePei);
        }

        //撈天然災害漁業產物損失
        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
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
                        $("#FishLoss_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FishLossYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Fa_FishLoss").text().trim()).toFixed(0)) + '千元' + '</td>';
                                Farming_All_Array.push($(this).children("Fa_FishLoss").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#FishLoss_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //撈臺閩地區農業天然災害產物損失
        function getFarmingLoss() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
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
                        $("#FarmingLoss_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmingLossYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Fa_FarmingLoss").text().trim()).toFixed(0)) + '千元' + '</td>';
                                Farming_All_Array.push((Number($(this).children("Fa_FarmingLoss").text().trim()).toFixed(0)));
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#FarmingLoss_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //撈天然災害畜牧業產物損失
        function getAnimalLoss() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
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
                        $("#AnimalLoss_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_AnimalLossYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Fa_AnimalLoss").text().trim()).toFixed(0)) + '千元' + '</td>';
                                Farming_All_Array.push(Number($(this).children("Fa_AnimalLoss").text().trim()).toFixed(0));
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#AnimalLoss_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //撈臺閩地區林業天然災害產物損失
        function getForestLoss() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
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
                        $("#ForestLoss_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_ForestLossYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Fa_ForestLoss").text().trim()).toFixed(0)) + '千元' + '</td>';
                                Farming_All_Array.push(Number($(this).children("Fa_ForestLoss").text().trim()).toFixed(0));
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#ForestLoss_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //農林漁牧天然災害產物損失
        function getFAllLoss() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
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
                        $("#AllLoss_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_AllLossYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Fa_AllLoss").text().trim()).toFixed(0)) + '千元' + '</td>';
                                Farming_All_Array.push(Number($(this).children("Fa_AllLoss").text().trim()).toFixed(0));
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#AllLoss_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //農林漁牧天然災害設施(備)損失
        function getFacilityLoss() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
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
                        $("#FacilityLoss_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FacilityLossYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Fa_FacilityLoss").text().trim()).toFixed(0)) + '千元' + '</td>';
                                Farming_All_Array.push($(this).children("Fa_FacilityLoss").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#FacilityLoss_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //農業產值
        function getFarmingOutputValue() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
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
                        $("#FarmingOutputValue_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmingOutputValueYear").text().trim() + '年' + '</td>';
                                var tmpVal = ($.isNumeric($(this).children("Fa_FarmingOutputValue").text().trim())) ? Number($(this).children("Fa_FarmingOutputValue").text().trim()).toFixed(2) : 0;
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(tmpVal) + '千元' + '</td>';
                                Farming_All_Array.push(tmpVal);
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#FarmingOutputValue_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //農業產值成長率
        function getFarmingOutputRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
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
                        $("#FarmingOutputRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmingOutputRateYearDesc").text().trim() + '年' + '</td>';
                                var tmpVal = ($.isNumeric($(this).children("Fa_FarmingOutputRate").text().trim())) ? Number($(this).children("Fa_FarmingOutputRate").text().trim()).toFixed(2) : 0;
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(tmpVal) + '%' + '</td>';
                                Farming_All_Array.push(tmpVal);
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#FarmingOutputRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //農戶人口數
        function getFarmer() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
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
                        $("#Farmer_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmerYear").text().trim() + '年' + '</td>';
                                var tmpVal = ($.isNumeric($(this).children("Fa_Farmer").text().trim())) ? Number($(this).children("Fa_Farmer").text().trim()).toFixed(0) : 0;
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(tmpVal) + '人' + '</td>';
                                Farming_All_Array.push(tmpVal);
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#Farmer_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //平均農業從業人口產值
        function getFarmEmploymentOutputValue() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
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
                        $("#FarmEmploymentOutputValue_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmEmploymentOutputValueYear").text().trim() + '年' + '</td>';
                                var tmpVal = ($.isNumeric($(this).children("Fa_FarmEmploymentOutputValue").text().trim())) ? Number($(this).children("Fa_FarmEmploymentOutputValue").text().trim()).toFixed(0) : 0;
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(tmpVal) + '千元' + '</td>';
                                Farming_All_Array.push(tmpVal);
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#FarmEmploymentOutputValue_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

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
                            y: parseFloat(Farming_All_Array[1])
                        },
                        {
                            name: '新北市',
                            y: parseFloat(Farming_All_Array[0])
                        },
                        {
                            name: '基隆市',
                            y: parseFloat(Farming_All_Array[17])
                        },
                        {
                            name: '桃園市',
                            y: parseFloat(Farming_All_Array[2])
                        },
                        {
                            name: '宜蘭縣',
                            y: parseFloat(Farming_All_Array[6])
                        },
                        {
                            name: '新竹縣',
                            y: parseFloat(Farming_All_Array[7])
                        },
                        {
                            name: '新竹市',
                            y: parseFloat(Farming_All_Array[18])
                        },
                        {
                            name: '苗栗縣',
                            y: parseFloat(Farming_All_Array[8])
                        },
                        {
                            name: '臺中市',
                            y: parseFloat(Farming_All_Array[3])
                        },
                        {
                            name: '彰化縣',
                            y: parseFloat(Farming_All_Array[9])
                        },
                        {
                            name: '南投縣',
                            y: parseFloat(Farming_All_Array[10])
                        },
                        {
                            name: '雲林縣',
                            y: parseFloat(Farming_All_Array[11])
                        },
                        {
                            name: '嘉義縣',
                            y: parseFloat(Farming_All_Array[12])
                        },
                        {
                            name: '嘉義市',
                            y: parseFloat(Farming_All_Array[19])
                        },
                        {
                            name: '臺南市',
                            y: parseFloat(Farming_All_Array[4])
                        },
                        {
                            name: '高雄市',
                            y: parseFloat(Farming_All_Array[5])
                        },
                        {
                            name: '屏東縣',
                            y: parseFloat(Farming_All_Array[13])
                        },
                        {
                            name: '花蓮縣',
                            y: parseFloat(Farming_All_Array[15])
                        },
                        {
                            name: '臺東縣',
                            y: parseFloat(Farming_All_Array[14])
                        },
                        {
                            name: '金門縣',
                            y: parseFloat(Farming_All_Array[20])
                        },
                        {
                            name: '連江縣',
                            y: parseFloat(Farming_All_Array[21])
                        },
                        {
                            name: '澎湖縣',
                            y: parseFloat(Farming_All_Array[16])
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
                <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 農業</div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div style="margin-top: 10px;">
                類別：
        <select id="selType" name="selClass" class="inputex">
            <option value="01">天然災害漁業產物損失</option>
            <option value="02">臺閩地區農業天然災害產物損失</option>
            <option value="03">天然災害畜牧業產物損失</option>
            <option value="04">臺閩地區林業天然災害產物損失</option>
            <option value="05">農林漁牧天然災害產物損失</option>
            <option value="06">農林漁牧天然災害設施(備)損失</option>
            <option value="07">農業產值</option>
            <option value="08">農業產值成長率</option>
            <option value="09">農戶人口數</option>
            <option value="10">平均農業從業人口產值</option>
        </select>
            </div>
            <div class="row margin10T ">
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                        <%--天然災害漁業產物損失--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="FishLoss_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_FishLoss">農林漁牧天然災害產物損失</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--臺閩地區農業天然災害產物損失--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="FarmingLoss_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_FarmingLoss">臺閩地區農業天然災害產物損失</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--天然災害畜牧業產物損失--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="AnimalLoss_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_AnimalLoss">天然災害畜牧業產物損失</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--臺閩地區林業天然災害產物損失--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="ForestLoss_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_ForestLoss">臺閩地區林業天然災害產物損失</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--農林漁牧天然災害產物損失--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="AllLoss_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_AllLoss">農林漁牧天然災害產物損失</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--農林漁牧天然災害設施(備)損失--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="FacilityLoss_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_FacilityLoss">農林漁牧天然災害設施(備)損失</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--農業產值--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="FarmingOutputValue_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_FarmingOutputValue">農業產值</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--農業產值成長率--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="FarmingOutputRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_FarmingOutputRate">農業產值成長率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--農戶人口數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Farmer_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_Farmer">農戶人口數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--平均農業從業人口產值--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="FarmEmploymentOutputValue_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Fa_FarmEmploymentOutputValue">平均農業從業人口產值</a></th>
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
