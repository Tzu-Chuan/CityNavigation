<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Education_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Education_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            // 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "Edu_CityNo";

            getdll();
            
            if ($.getQueryString("tp") != "")
                $("#dll_Category").val($.getQueryString("tp"));

            getData();

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
                
                getData();
            });

            // 切換下拉選單
            $(document).on("change", "#dll_Category", function () {
                $("a[name='sortbtn']").removeClass("asc desc");
                Page.Option.SortMethod = "+";
                Page.Option.SortName = "Edu_CityNo";
                getData();
            });
        });// end js

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
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            var objData = new Object();
                            var JsonStr = "", Unit = "", DataYear = "", DataVal = "", FloatNum = 0;
                            $("#UnitHead").html($("#dll_Category").find("option:selected").text());
                            switch ($("#dll_Category").val()) {
                                case "01":
                                    $("#UnitHead").attr("sortname", "Edu_15upJSDownRate");
                                    Unit = "%";
                                    DataYear = "Edu_15upJSDownRateYear";
                                    DataVal = "Edu_15upJSDownRate";
                                    FloatNum = 2;
                                    break;
                                case "02":
                                    $("#UnitHead").attr("sortname", "Edu_15upHSRate");
                                    Unit = "%";
                                    DataYear = "Edu_15upHSRateYear";
                                    DataVal = "Edu_15upHSRate";
                                    FloatNum = 2;
                                    break;
                                case "03":
                                    $("#UnitHead").attr("sortname", "Edu_15upUSUpRate");
                                    Unit = "%";
                                    DataYear = "Edu_15upUSUpRateYear";
                                    DataVal = "Edu_15upUSUpRate";
                                    FloatNum = 2;
                                    break;
                                case "04":
                                    $("#UnitHead").attr("sortname", "Edu_ESStudents");
                                    Unit = "人";
                                    DataYear = "Edu_ESStudentsYear";
                                    DataVal = "Edu_ESStudents";
                                    break;
                                case "05":
                                    $("#UnitHead").attr("sortname", "Edu_ESStudentDropOutRate");
                                    Unit = "%";
                                    DataYear = "Edu_ESStudentDropOutRateYear";
                                    DataVal = "Edu_ESStudentDropOutRate";
                                    FloatNum = 2;
                                    break;
                                case "06":  
                                    $("#UnitHead").attr("sortname", "Edu_JSStudents");
                                    Unit = "人";
                                    DataYear = "Edu_JSStudentsYear";
                                    DataVal = "Edu_JSStudents";
                                    break;
                                case "07":
                                    $("#UnitHead").attr("sortname", "Edu_JSStudentDropOutRate");
                                    Unit = "%";
                                    DataYear = "Edu_JSStudentDropOutRateYear";
                                    DataVal = "Edu_JSStudentDropOutRate";
                                    FloatNum = 2;
                                    break;
                                case "08":
                                    $("#UnitHead").attr("sortname", "Edu_HSStudents");
                                    Unit = "人";
                                    DataYear = "Edu_HSStudentsYear";
                                    DataVal = "Edu_HSStudents";
                                    break;
                                case "09":
                                    $("#UnitHead").attr("sortname", "Edu_ESToHSIdigenous");
                                    Unit = "人";
                                    DataYear = "Edu_ESToHSIndigenousYear";
                                    DataVal = "Edu_ESToHSIdigenous";
                                    break;
                                case "10":
                                    $("#UnitHead").attr("sortname", "Edu_ESToHSIndigenousRate");
                                    Unit = "%";
                                    DataYear = "Edu_ESToHSIndigenousRateYear";
                                    DataVal = "Edu_ESToHSIndigenousRate";
                                    FloatNum = 2;
                                    break;
                                case "11":
                                    $("#UnitHead").attr("sortname", "Edu_ESJSNewInhabitants");
                                    Unit = "人";
                                    DataYear = "Edu_ESJSNewInhabitantsYear";
                                    DataVal = "Edu_ESJSNewInhabitants";
                                    break;
                                case "12":
                                    $("#UnitHead").attr("sortname", "Edu_ESToJSNewInhabitantsRate");
                                    Unit = "%";
                                    DataYear = "Edu_ESJSNewInhabitantsRateYear";
                                    DataVal = "Edu_ESToJSNewInhabitantsRate";
                                    FloatNum = 2;
                                    break;
                                case "13":  
                                    $("#UnitHead").attr("sortname", "Edu_ESJSTeachers");
                                    Unit = "人";
                                    DataYear = "Edu_ESJSTeachersYear";
                                    DataVal = "Edu_ESJSTeachers";
                                    break;
                                case "14":
                                    $("#UnitHead").attr("sortname", "Edu_ESJSTeachersOfStudentRate");
                                    Unit = "%";
                                    DataYear = "Edu_ESJSTeachersOfStudentRateYear";
                                    DataVal = "Edu_ESJSTeachersOfStudentRate";
                                    FloatNum = 2;
                                    break;
                                case "15":
                                    $("#UnitHead").attr("sortname", "Edu_Budget");
                                    Unit = "千元";
                                    DataYear = "Edu_BudgetYear";
                                    DataVal = "Edu_Budget";
                                    FloatNum = 2;
                                    break;
                                case "16":
                                    $("#UnitHead").attr("sortname", "Edu_BudgetUpRate");
                                    Unit = "%";
                                    DataYear = "Edu_BudgetUpRateYearDesc";
                                    DataVal = "Edu_BudgetUpRate";
                                    FloatNum = 2;
                                    break;
                                case "17":  
                                    $("#UnitHead").attr("sortname", "Edu_ESToHSAvgBudget");
                                    Unit = "千元";
                                    DataYear = "Edu_ESToHSAvgBudgetYear";
                                    DataVal = "Edu_ESToHSAvgBudget";
                                    break;
                                case "18":
                                    $("#UnitHead").attr("sortname", "Edu_ESJSPCNum");
                                    Unit = "台";
                                    DataYear = "Edu_ESJSPCNumYear";
                                    DataVal = "Edu_ESJSPCNum";
                                    break;
                                case "19":
                                    $("#UnitHead").attr("sortname", "Edu_ESJSAvgPCNum");
                                    Unit = "台";
                                    DataYear = "Edu_ESJSAvgPCNumYear";
                                    DataVal = "Edu_ESJSAvgPCNum";
                                    FloatNum = 2;
                                    break;
                            }
                            $(data).find("data_item").each(function (i) {
                                var tmpV = ($.isNumeric($(this).children(DataVal).text().trim())) ? Number($(this).children(DataVal).text().trim()) : 0;
                                // Table
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children(DataYear).text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(tmpV.toFixed(FloatNum)) + ' ' + Unit + '</td>';
                                tabstr += '</td></tr>';

                                // Hightchart Json
                                objData.name = $(this).children("Edu_CityName").text().trim();
                                // 0 & 負數 不進 highchart
                                if (tmpV > 0) {
                                    objData.y = tmpV;
                                    if (JsonStr != '') JsonStr += ',';
                                    JsonStr += JSON.stringify(objData);
                                }
                            });

                            JsonStr = "[" + JsonStr + "]";
                            DrawChart(JsonStr);
                            $("#tablist tbody").empty();
                            $("#tablist tbody").append(tabstr);
                            $(".hugetable table").tableHeadFixer({ "left": 0 });
                        }
                    }
                }
            });
        }
        
        function getdll() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetGlobalDDL.aspx",
                data: {
                    group: "Education"
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        var ddlstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                ddlstr += '<option value="' + $(this).children("K_ItemNo").text().trim() + '">' + $(this).children("K_Word").text().trim() + '</option>';
                            });
                            $("#dll_Category").empty();
                            $("#dll_Category").append(ddlstr);
                        }
                    }
                }
            });
        }

        //hightchart
        function DrawChart(JStr) {
            //圓餅圖
            $('#ChartDiv').highcharts({
                chart: {
                    type: 'pie'
                },
                title: {
                    text: $("#dll_Category").find("option:selected").text()
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true
                        },
                        showInLegend: false
                    }
                },
                series: [{
                    name: '',
                    colorByPoint: true,
                    data: $.parseJSON(JStr)
                }]
            });
        }
       

        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="twocol titleLineA">
        <div class="left"><span class="font-size4">全國資料</span></div>
        <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 教育</div>
    </div>

    <div class="margin20T">
        類別：<select id="dll_Category" class="inputex"></select>
    </div>
    <div class="row margin20T">
        <div class="col-lg-6 col-md-6 col-sm-12">
            <div class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                <table border="0" cellspacing="0" cellpadding="0" width="100%" id="tablist">
                    <thead>
                        <tr>
                            <th nowrap="nowrap" style="width: 50px;"><a href="javascript:void(0);" name="sortbtn" sortname="Edu_CityNo">縣市</a></th>
                            <th nowrap="nowrap" style="width: 50px;">資料時間</th>
                            <th nowrap="nowrap" style="width: 150px;"><a id="UnitHead" href="javascript:void(0);" name="sortbtn">年底戶籍總人口數</a></th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div><!-- col -->
        <div class="col-lg-6 col-md-6 col-sm-12">
            <div id="ChartDiv" class="maxWithA"></div>
        </div><!-- col -->
    </div>
</asp:Content>
