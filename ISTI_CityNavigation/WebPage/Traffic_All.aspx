<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Traffic_All.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Traffic_All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            // 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "Tra_CityNo";

            getdll();
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
                Page.Option.SortName = "Tra_CityNo";
                $("#UnitHead").html($(this).find("option:selected").text()); 
                getData();
            });
        });// end js

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
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            var objData = new Object();
                            var JsonStr = "", Unit = "", DataYear = "", DataVal = "", FloatNum = 0;
                            switch ($("#dll_Category").val()) {
                                case "01":
                                    $("#UnitHead").attr("sortname", "Tra_PublicTransportRate");
                                    Unit = "%";
                                    DataYear = "Tra_PublicTransportRateYear";
                                    DataVal = "Tra_PublicTransportRate";
                                    FloatNum = 1;
                                    break;
                                case "02":
                                    $("#UnitHead").attr("sortname", "Tra_CarParkTime");
                                    Unit = "分鐘";
                                    DataYear = "Tra_CarParkTimeYear";
                                    DataVal = "Tra_CarParkTime";
                                    FloatNum = 1;
                                    break;
                                case "03":
                                    $("#UnitHead").attr("sortname", "Tra_CarRoadsidParkSpace");
                                    Unit = "個";
                                    DataYear = "Tra_CarRoadsidParkSpaceYear";
                                    DataVal = "Tra_CarRoadsidParkSpace";
                                    break;
                                case "04":
                                    $("#UnitHead").attr("sortname", "Tra_CarRoadOutsideParkSpace");
                                    Unit = "個";
                                    DataYear = "Tra_CarRoadOutsideParkSpaceYear";
                                    DataVal = "Tra_CarRoadOutsideParkSpace";
                                    break;
                                case "05":
                                    $("#UnitHead").attr("sortname", "Tra_10KHaveCarPark");
                                    Unit = "位／萬輛";
                                    DataYear = "Tra_10KHaveCarParkYear";
                                    DataVal = "Tra_10KHaveCarPark";
                                    FloatNum = 2;
                                    break;
                                case "06":
                                    $("#UnitHead").attr("sortname", "Tra_CarCount");
                                    Unit = "輛";
                                    DataYear = "Tra_CarCountYear";
                                    DataVal = "Tra_CarCount";
                                    FloatNum = 1;
                                    break;
                                case "07":
                                    $("#UnitHead").attr("sortname", "Tra_100HaveCar");
                                    Unit = "輛";
                                    DataYear = "Tra_100HaveCarYear";
                                    DataVal = "Tra_100HaveCar";
                                    FloatNum = 1;
                                    break;
                                case "08":
                                    $("#UnitHead").attr("sortname", "Tra_100HaveCarRate");
                                    Unit = "%";
                                    DataYear = "Tra_100HaveCarRateYearDec";
                                    DataVal = "Tra_100HaveCarRate";
                                    FloatNum = 2;
                                    break;
                                case "09":
                                    $("#UnitHead").attr("sortname", "Tra_10KMotoIncidentsNum");
                                    Unit = "次";
                                    DataYear = "Tra_10KMotoIncidentsNumYear";
                                    DataVal = "Tra_10KMotoIncidentsNum";
                                    FloatNum = 2;
                                    break;
                                case "10":
                                    $("#UnitHead").attr("sortname", "Tra_100KNumberOfCasualties");
                                    Unit = "人";
                                    DataYear = "Tra_100KNumberOfCasualtiesYear";
                                    DataVal = "Tra_100KNumberOfCasualties";
                                    FloatNum = 2;
                                    break;
                            }
                            $(data).find("data_item").each(function (i) {
                                var tmpV = ($.isNumeric($(this).children(DataVal).text().trim())) ? Number($(this).children(DataVal).text().trim()) : 0;
                                // Table
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CityName").text().trim() + '</td>';
                                if(DataYear!="Tra_100HaveCarRateYearDec")
                                    tabstr += '<td align="center" nowrap="nowrap">' + $(this).children(DataYear).text().trim() + '年' + '</td>';
                                else
                                    tabstr += '<td align="center" nowrap="nowrap">' + $(this).children(DataYear).text().trim() + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(tmpV.toFixed(FloatNum)) + ' ' + Unit + '</td>';
                                tabstr += '</td></tr>';

                                // Hightchart Json
                                objData.name = $(this).children("Tra_CityName").text().trim();
                                var tmpV = ($.isNumeric($(this).children(DataVal).text().trim())) ? Number($(this).children(DataVal).text().trim()) : 0;
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
                    group: "Traffic"
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
        <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 交通</div>
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
                            <th nowrap="nowrap" style="width: 50px;"><a href="javascript:void(0);" name="sortbtn" sortname="Tra_CityNo">縣市</a></th>
                            <th nowrap="nowrap" style="width: 50px;">資料時間</th>
                            <th nowrap="nowrap" style="width: 150px;"><a id="UnitHead" href="javascript:void(0);" name="sortbtn">通勤學民眾運具次數之公共運具市佔率</a></th>
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
