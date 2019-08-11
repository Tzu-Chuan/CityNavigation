<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Pop_all.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.Pop_all" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            // 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "P_CityNo";

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
                Page.Option.SortName = "P_CityNo";
                $("#UnitHead").html($(this).find("option:selected").text()); 
                getData();
            });
        });// end js


        function getData() {
            $.ajax({
                type: "POST",
                async: true, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: "All",
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod,
                    Token: $("#InfoToken").val()
                },
                beforeSend: function () {
                    $("#tablist tbody").empty();
                    $("#tablist tbody").append('<tr><td colspan="3"><img src="../images/loading.gif" width="40"/>資料讀取中...</td></tr>');
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
                            var JsonStr = "";
                            $(data).find("data_item").each(function (i) {
                                // Hightchart Json
                                objData.name = $(this).children("P_CityName").text().trim();
                                // Table
                                tabstr += '<tr>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_CityName").text().trim() + '</td>';
                                switch ($("#dll_Category").val()) {
                                    case "01":
                                        // Hightchart Json
                                        objData.y = ($.isNumeric($(this).children("P_PeopleTotal").text().trim())) ? Number($(this).children("P_PeopleTotal").text().trim()) : 0;
                                        // Table Header Sort
                                        $("#UnitHead").attr("sortname", "P_PeopleTotal");
                                        tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_TotalYear").text().trim() + '年' + '</td>';
                                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_PeopleTotal").text().trim()).toFixed(0)) + ' 人</td>';
                                        break;
                                    case "02":
                                        $("#UnitHead").attr("sortname", "P_PeopleTotalPercent");
                                        tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_PeopleTotalPercentYear").text().trim() + '年' + '</td>';
                                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_PeopleTotalPercent").text().trim()).toFixed(2)) + ' %</td>';
                                        break;
                                    case "03":
                                        $("#UnitHead").attr("sortname", "P_Area");
                                        tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_AreaYear").text().trim() + '年' + '</td>';
                                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_Area").text().trim()).toFixed(2)) + ' k㎡</td>';
                                        break;
                                    case "04":
                                        $("#UnitHead").attr("sortname", "P_Child");
                                        tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_ChildYear").text().trim() + '年' + '</td>';
                                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_Child").text().trim()).toFixed(0)) + ' 人</td>';
                                        break;
                                    case "05":
                                        $("#UnitHead").attr("sortname", "P_ChildPercent");
                                        tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_ChildPercentYear").text().trim() + '年' + '</td>';
                                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_ChildPercent").text().trim()).toFixed(2)) + ' %</td>';
                                        break;
                                    case "06":
                                        $("#UnitHead").attr("sortname", "P_Teenager");
                                        tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_TeenagerYear").text().trim() + '年' + '</td>';
                                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_Teenager").text().trim()).toFixed(0)) + ' 人</td>';
                                        break;
                                    case "07":
                                        $("#UnitHead").attr("sortname", "P_TeenagerPercent");
                                        tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_TeenagerPercentYear").text().trim() + '年' + '</td>';
                                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_TeenagerPercent").text().trim()).toFixed(2)) + ' %</td>';
                                        break;
                                    case "08":
                                        $("#UnitHead").attr("sortname", "P_OldMen");
                                        tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_OldMenYear").text().trim() + '年' + '</td>';
                                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_OldMen").text().trim()).toFixed(0)) + ' 人</td>';
                                        break;
                                    case "09":
                                        $("#UnitHead").attr("sortname", "P_OldMenPercent");
                                        tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_OldMenPercentYear").text().trim() + '年' + '</td>';
                                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($(this).children("P_OldMenPercent").text().trim()).toFixed(2)) + ' %</td>';
                                        break;
                                }
                                tabstr += '</td></tr>';

                                // Hightchart Json
                                if (JsonStr != '') JsonStr += ',';
                                JsonStr += JSON.stringify(objData);
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
                    group: "Population"
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
        <div class="right"><a href="CityInfo.aspx?city=02">首頁</a> / 全國資料 / 土地人口</div>
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
                            <th nowrap="nowrap" style="width: 50px;"><a href="javascript:void(0);" name="sortbtn" sortname="P_CityNo">縣市</a></th>
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
    </div><!-- row -->
</asp:Content>
