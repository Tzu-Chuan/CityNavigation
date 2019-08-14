<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Health_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Health_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            // 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "Hea_CityNo";

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
                Page.Option.SortName = "Hea_CityNo";
                getData();
            });
        });// end js

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
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            var objData = new Object();
                            var JsonStr = "", Unit = "", DataYear = "", DataVal = "", FloatNum = 0;
                            $("#UnitHead").html($("#dll_Category").find("option:selected").text());
                            switch ($("#dll_Category").val()) {
                                case "01":
                                    $("#UnitHead").attr("sortname", "Hea_10KPeopleBed");
                                    Unit = "床";
                                    DataYear = "Hea_10KPeopleBedYear";
                                    DataVal = "Hea_10KPeopleBed";
                                    FloatNum = 2;
                                    break;
                                case "02":
                                    $("#UnitHead").attr("sortname", "Hea_10KPeopleAcuteGeneralBed");
                                    Unit = "床";
                                    DataYear = "Hea_10KPeopleAcuteGeneralBedYear";
                                    DataVal = "Hea_10KPeopleAcuteGeneralBed";
                                    break;
                                case "03":
                                    $("#UnitHead").attr("sortname", "Hea_10KpeoplePractitioner");
                                    Unit = "人";
                                    DataYear = "Hea_10KpeoplePractitionerYear";
                                    DataVal = "Hea_10KpeoplePractitioner";
                                    FloatNum = 2;
                                    break;
                                case "04":
                                    $("#UnitHead").attr("sortname", "Hea_DisabledPersonOfCityRate");
                                    Unit = "%";
                                    DataYear = "Hea_DisabledPersonOfCityRateYear";
                                    DataVal = "Hea_DisabledPersonOfCityRate";
                                    FloatNum = 2;
                                    break;
                                case "05":
                                    $("#UnitHead").attr("sortname", "Hea_LongTermPerson");
                                    Unit = "人";
                                    DataYear = "Hea_LongTermPersonYear";
                                    DataVal = "Hea_LongTermPerson";
                                    break;
                                case "06":
                                    $("#UnitHead").attr("sortname", "Hea_LongTermPersonOfOldMenRate");
                                    Unit = "%";
                                    DataYear = "Hea_LongTermPersonOfOldMenRateYear";
                                    DataVal = "Hea_LongTermPersonOfOldMenRate";
                                    FloatNum = 2;
                                    break;
                                case "07":
                                    $("#UnitHead").attr("sortname", "Hea_MedicalInstitutions");
                                    Unit = "所";
                                    DataYear = "Hea_MedicalInstitutionsYear";
                                    DataVal = "Hea_MedicalInstitutions";
                                    break;
                                case "08":
                                    $("#UnitHead").attr("sortname", "Hea_MedicalInstitutionsAvgPerson");
                                    Unit = "人/所";
                                    DataYear = "Hea_MedicalInstitutionsAvgPersonYear";
                                    DataVal = "Hea_MedicalInstitutionsAvgPerson";
                                    break;
                                case "09":  
                                    $("#UnitHead").attr("sortname", "Hea_GOVPayOfNHI");
                                    Unit = "千元";
                                    DataYear = "Hea_GOVPayOfNHIYear";
                                    DataVal = "Hea_GOVPayOfNHI";
                                    break;
                            }
                            $(data).find("data_item").each(function (i) {
                                var tmpV = ($.isNumeric($(this).children(DataVal).text().trim())) ? Number($(this).children(DataVal).text().trim()) : 0;
                                // Table
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_CityName").text().trim() + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children(DataYear).text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(tmpV.toFixed(FloatNum)) + ' ' + Unit + '</td>';
                                tabstr += '</td></tr>';

                                // Hightchart Json
                                objData.name = $(this).children("Hea_CityName").text().trim();
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
                    group: "Health"
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
        <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 健康</div>
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
                            <th nowrap="nowrap" style="width: 50px;"><a href="javascript:void(0);" name="sortbtn" sortname="Hea_CityNo">縣市</a></th>
                            <th nowrap="nowrap" style="width: 50px;">資料時間</th>
                            <th nowrap="nowrap" style="width: 150px;"><a id="UnitHead" href="javascript:void(0);" name="sortbtn">每萬人口病床數</a></th>
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
