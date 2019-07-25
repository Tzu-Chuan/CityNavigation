<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Health_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Health_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".CityClass").hide();

            /// 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "Hea_CityNo";

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
                        get10KPeopleBed();
                        break;
                    case "03":
                        get10KPeopleAcuteGeneralBed();
                        break;
                    case "04":
                        get10KpeoplePractitioner();
                        titlePei = "每萬人執業醫事人員數";
                        break;
                    case "05":
                        getDisabledPersonOfCityRate();
                        break;
                    case "06":
                        getLongTermPersonOfOldMenRate();
                        break;
                    case "07":
                        getMedicalInstitutions();
                        break;
                    case "08":
                        getMedicalInstitutionsAvgPerson();
                        break;

                    case "09":
                        getGOVPayOfNHI();
                        break;
                }
            });

            defaultInfo();

            $(document).on("change", "#selType", function () {
                $(".CityClass").hide();
                Page.Option.SortMethod = "+";
                Page.Option.SortName = "Hea_CityNo";
                Health_All_Array.length = 0;
                switch ($("#selType").val()) {
                    case "01":
                        document.getElementById("LongTermPerson_tablist").style.display = "";
                        getData();
                        titlePei = "長期照顧機構可供進駐人數";
                        DrawChart(titlePei);
                        break;
                    case "02":
                        document.getElementById("10KPeopleBed_tablist").style.display = "";
                        get10KPeopleBed();
                        titlePei = "每萬人口病床數";
                        DrawChart(titlePei);
                        break;
                    case "03":
                        document.getElementById("10KPeopleAcuteGeneralBed_tablist").style.display = "";
                        get10KPeopleAcuteGeneralBed();
                        titlePei = "每萬人口急性一般病床數";
                        DrawChart(titlePei);
                        break;
                    case "04":
                        document.getElementById("10KpeoplePractitioner_tablist").style.display = "";
                        get10KpeoplePractitioner();
                        titlePei = "每萬人執業醫事人員數";
                        DrawChart(titlePei);
                        break;
                    case "05":
                        document.getElementById("DisabledPersonOfCityRate_tablist").style.display = "";
                        getDisabledPersonOfCityRate();
                        titlePei = "身心障礙人口占全縣(市)總人口比率";
                        DrawChart(titlePei);
                        break;
                    case "06":
                        document.getElementById("LongTermPersonOfOldMenRate_tablist").style.display = "";
                        getLongTermPersonOfOldMenRate();
                        titlePei = "長期照顧機構可供進駐人數佔預估失能老人需求比例";
                        DrawChart(titlePei);
                        break;
                    case "07":
                        document.getElementById("MedicalInstitutions_tablist").style.display = "";
                        getMedicalInstitutions();
                        titlePei = "醫療機構數";
                        DrawChart(titlePei);
                        break;
                    case "08":
                        document.getElementById("MedicalInstitutionsAvgPerson_tablist").style.display = "";
                        getMedicalInstitutionsAvgPerson();
                        titlePei = "平均每一醫療機構服務人數";
                        DrawChart(titlePei);
                        break;

                    case "09":
                        document.getElementById("GOVPayOfNHI_tablist").style.display = "";
                        getGOVPayOfNHI();
                        titlePei = "政府部門醫療保健支出";
                        DrawChart(titlePei);
                        break;
                }
            });
        }); //js end


        var Health_All_Array = [];
        function defaultInfo() {
            document.getElementById("LongTermPerson_tablist").style.display = "";
            getData();
            titlePei = "長期照顧機構可供進駐人數";
            DrawChart(titlePei);
        }

        //長期照顧機構可供進駐人數
        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
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
                        $("#LongTermPerson_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_LongTermPersonYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Hea_LongTermPerson").text().trim()).toFixed(0)) + '人' + '</td>';
                                Health_All_Array.push($(this).children("Hea_LongTermPerson").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#LongTermPerson_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //每萬人口病床數
        function get10KPeopleBed() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
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
                        $("#10KPeopleBed_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_10KPeopleBedYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Hea_10KPeopleBed").text().trim()).toFixed(2)) + '床' + '</td>';
                                Health_All_Array.push($(this).children("Hea_10KPeopleBed").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#10KPeopleBed_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //每萬人口急性一般病床數
        function get10KPeopleAcuteGeneralBed() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
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
                        $("#10KPeopleAcuteGeneralBed_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_10KPeopleAcuteGeneralBedYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Hea_10KPeopleAcuteGeneralBed").text().trim()).toFixed(0)) + '床' + '</td>';
                                Health_All_Array.push($.FormatThousandGroup(Number($(this).children("Hea_10KPeopleAcuteGeneralBed").text().trim()).toFixed(0)));
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#10KPeopleAcuteGeneralBed_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //每萬人口急性一般病床數
        function get10KpeoplePractitioner() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
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
                        $("#10KpeoplePractitioner_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_10KpeoplePractitionerYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Hea_10KpeoplePractitioner").text().trim()).toFixed(2)) + '人' + '</td>';
                                Health_All_Array.push($(this).children("Hea_10KpeoplePractitioner").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#10KpeoplePractitioner_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //身心障礙人口占全縣(市)總人口比率
        function getDisabledPersonOfCityRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
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
                        $("#DisabledPersonOfCityRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_DisabledPersonOfCityRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Hea_DisabledPersonOfCityRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Health_All_Array.push($(this).children("Hea_DisabledPersonOfCityRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#DisabledPersonOfCityRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //長期照顧機構可供進駐人數佔預估失能老人需求比例
        function getLongTermPersonOfOldMenRate() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
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
                        $("#LongTermPersonOfOldMenRate_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_LongTermPersonOfOldMenRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Hea_LongTermPersonOfOldMenRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                Health_All_Array.push($(this).children("Hea_LongTermPersonOfOldMenRate").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#LongTermPersonOfOldMenRate_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //醫療機構數
        function getMedicalInstitutions() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
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
                        $("#MedicalInstitutions_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_MedicalInstitutionsYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Hea_MedicalInstitutions").text().trim()).toFixed(0)) + '所' + '</td>';
                                Health_All_Array.push($(this).children("Hea_MedicalInstitutions").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#MedicalInstitutions_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //平均每一醫療機構服務人數
        function getMedicalInstitutionsAvgPerson() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
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
                        $("#MedicalInstitutionsAvgPerson_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_MedicalInstitutionsAvgPersonYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Hea_MedicalInstitutionsAvgPerson").text().trim()).toFixed(0)) + '人/所' + '</td>';
                                Health_All_Array.push($(this).children("Hea_MedicalInstitutionsAvgPerson").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#MedicalInstitutionsAvgPerson_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
                    }
                }
            })
        }

        //政府部門醫療保健支出
        function getGOVPayOfNHI() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
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
                        $("#GOVPayOfNHI_tablist tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_GOVPayOfNHIYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("Hea_GOVPayOfNHI").text().trim()).toFixed(0)) + '千元' + '</td>';
                                Health_All_Array.push($(this).children("Hea_GOVPayOfNHI").text().trim().toString());
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        $("#GOVPayOfNHI_tablist tbody").append(tabstr);
                        // 固定表頭
                        // left : 左側兩欄固定(需為th)
                        $(".hugetable table").tableHeadFixer({ "left": 0 });
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
                            y: parseFloat(Health_All_Array[1])
                        },
                        {
                            name: '新北市',
                            y: parseFloat(Health_All_Array[0])
                        },
                        {
                            name: '基隆市',
                            y: parseFloat(Health_All_Array[17])
                        },
                        {
                            name: '桃園市',
                            y: parseFloat(Health_All_Array[2])
                        },
                        {
                            name: '宜蘭縣',
                            y: parseFloat(Health_All_Array[6])
                        },
                        {
                            name: '新竹縣',
                            y: parseFloat(Health_All_Array[7])
                        },
                        {
                            name: '新竹市',
                            y: parseFloat(Health_All_Array[18])
                        },
                        {
                            name: '苗栗縣',
                            y: parseFloat(Health_All_Array[8])
                        },
                        {
                            name: '臺中市',
                            y: parseFloat(Health_All_Array[3])
                        },
                        {
                            name: '彰化縣',
                            y: parseFloat(Health_All_Array[9])
                        },
                        {
                            name: '南投縣',
                            y: parseFloat(Health_All_Array[10])
                        },
                        {
                            name: '雲林縣',
                            y: parseFloat(Health_All_Array[11])
                        },
                        {
                            name: '嘉義縣',
                            y: parseFloat(Health_All_Array[12])
                        },
                        {
                            name: '嘉義市',
                            y: parseFloat(Health_All_Array[19])
                        },
                        {
                            name: '臺南市',
                            y: parseFloat(Health_All_Array[4])
                        },
                        {
                            name: '高雄市',
                            y: parseFloat(Health_All_Array[5])
                        },
                        {
                            name: '屏東縣',
                            y: parseFloat(Health_All_Array[13])
                        },
                        {
                            name: '花蓮縣',
                            y: parseFloat(Health_All_Array[15])
                        },
                        {
                            name: '臺東縣',
                            y: parseFloat(Health_All_Array[14])
                        },
                        {
                            name: '金門縣',
                            y: parseFloat(Health_All_Array[20])
                        },
                        {
                            name: '連江縣',
                            y: parseFloat(Health_All_Array[21])
                        },
                        {
                            name: '澎湖縣',
                            y: parseFloat(Health_All_Array[16])
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
                <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 健康</div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div style="margin-top: 10px;">
                類別：
        <select id="selType" name="selClass" class="inputex">
            <option value="01">長期照顧機構可供進駐人數</option>
            <option value="02">每萬人口病床數</option>
            <option value="03">每萬人口急性一般病床數</option>
            <option value="04">每萬人執業醫事人員數</option>
            <option value="05">身心障礙人口占全縣(市)總人口比率</option>
            <option value="06">長期照顧機構可供進駐人數佔預估失能老人需求比例</option>
            <option value="07">醫療機構數</option>
            <option value="08">平均每一醫療機構服務人數</option>
            <option value="09">政府部門醫療保健支出</option>
        </select>
            </div>
            <div class="row margin10T ">
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                        <%--長期照顧機構可供進駐人數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="LongTermPerson_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_LongTermPerson">長期照顧機構可供進駐人數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每萬人口病床數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="10KPeopleBed_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_10KPeopleBed">每萬人口病床數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每萬人口急性一般病床數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="10KPeopleAcuteGeneralBed_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_10KPeopleAcuteGeneralBed">每萬人口急性一般病床數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--每萬人執業醫事人員數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="10KpeoplePractitioner_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_10KpeoplePractitioner">每萬人執業醫事人員數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--身心障礙人口占全縣(市)總人口比率--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="DisabledPersonOfCityRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_DisabledPersonOfCityRate">身心障礙人口占全縣(市)總人口比率</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--長期照顧機構可供進駐人數佔預估失能老人需求比例--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="LongTermPersonOfOldMenRate_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_LongTermPersonOfOldMenRate">長期照顧機構可供進駐人數佔預估失能老人需求比例</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--醫療機構數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="MedicalInstitutions_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_MedicalInstitutions">醫療機構數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--平均每一醫療機構服務人數--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="MedicalInstitutionsAvgPerson_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_MedicalInstitutionsAvgPerson">平均每一醫療機構服務人數</a></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <%--政府部門醫療保健支出--%>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="GOVPayOfNHI_tablist" class="CityClass">
                            <thead>
                                <tr>
                                    <th nowrap="nowrap" style="width: 40px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_CityNo">縣市</a></th>
                                    <th nowrap="nowrap" style="width: 150px;">資料時間</th>
                                    <th nowrap="nowrap" style="width: 150px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_GOVPayOfNHI">政府部門醫療保健支出</a></th>
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
