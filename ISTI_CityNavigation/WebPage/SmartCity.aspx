<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="SmartCity.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.SmartCity" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            if ($.getQueryString("city") == "")
                location.href = "CityInfo.aspx";
            else if (Number($.getQueryString("city")) == 0 || Number($.getQueryString("city")) > 22)
                location.href = "CityInfo.aspx";
            else if (!$.isNumeric($.getQueryString("city")))
                location.href = "CityInfo.aspx";
            else {
                getData();
                getServiceTypePei();
            }
        });

        function getData() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPlanList.aspx",
                data: {
                    City: $.getQueryString("city")
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
                            // 動態增加各縣市的表頭欄位
                            var CityStr = data.querySelector("CP_City").textContent;
                            $("#tablist thead tr").append('<th nowrap name="newth">投入' + CityStr + '總經費(千元)</th><th nowrap name="newth">投入' + CityStr + '補助款(千元)</th>');
                            $(data).find("data_item").each(function (i) {
                                tabstr += '<tr>';
                                tabstr += '<td nowrap align="center">' + $(this).children("CP_PlanSchedule").text().trim() + '</td>';
                                tabstr += '<td nowrap align="center">' + $(this).children("CP_No").text().trim() + '</td>';
                                tabstr += '<td nowrap align="center">' + $(this).children("CP_PlanType").text().trim() + '</td>';
                                tabstr += '<td nowrap align="center">' + $(this).children("CP_HostCompany").text().trim() + '</td>';
                                tabstr += '<td align="center">' + $(this).children("CP_JointCompany").text().trim() + '</td>';
                                tabstr += '<td nowrap align="center">' + $(this).children("CP_PlanName").text().trim() + '</td>';
                                tabstr += '<td nowrap align="center">' + $(this).children("CP_ServiceType").text().trim() + '</td>';
                                tabstr += '<td align="center">' + $(this).children("CP_CityArea").text().trim() + '</td>';
                                tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CP_PlanTotalMoney").text().trim()).toFixed(0)) + '</td>';
                                tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CP_PlanSubMoney").text().trim()).toFixed(0)) + '</td>';
                                tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CP_CityTotalMoney").text().trim()).toFixed(0)) + '</td>';
                                tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CP_CitySubMoney").text().trim()).toFixed(0)) + '</td>';
                                tabstr += '</tr>';
                            });
                            $("#tablist tbody").empty();
                            $("#tablist tbody").append(tabstr);
                            // 固定表頭
                            // left : 左側兩欄固定(需為th)
                            $(".hugetable table").tableHeadFixer({ "left": 0 });
                        }
                        else
                            $("#TabDiv").html("<span style='font-size:14pt; color:red;'>查詢無資料</span>");
                    }
                }
            });
        }

        function getServiceTypePei() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetServiceTypeCount.aspx",
                data: {
                    City: $.getQueryString("city")
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if (data.ErrorMassage != undefined) {
                        alert(data.ErrorMassage);
                    }
                    else {
                        if (data.length > 0) {
                            var dataStr = new Object();
                            var JsonStr = "";
                            $.each(data, function (i, jv) {
                                dataStr.name = jv.CP_ServiceType;
                                dataStr.y = jv.TypeCount;
                                if (JsonStr != '') JsonStr += ',';
                                JsonStr += JSON.stringify(dataStr);
                            });
                            JsonStr = "[" + JsonStr + "]";
                            DrawChart(JsonStr);
                        }
                    }
                }
            });
        }

        function DrawChart(JStr) {
            $('#ServiceTypePei').highcharts({
                chart: {
                    type: 'pie'
                },
                title: {
                    text: '應用服務別'
                },
                series: [{
                    name: '',
                    colorByPoint: true,
                    data: $.parseJSON(JStr)
                }]
            });
        }
        
        // 千分位
        function FormatNumber(n) {
            n = Number(n); // 去小數點為0
            n += ""; // 轉字串
            var arr = n.split(".");
            var re = /(\d{1,3})(?=(\d{3})+$)/g;
            return arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="twocol titleLineA">
        <div class="left"><span class="font-size4"><%= CityName %>智慧城鄉計畫提案</span></div><!-- left -->
        <div class="right">首頁 / <%= CityName %> / <%= CityName %>智慧城鄉計畫提案</div><!-- right -->
    </div><!-- twocol -->

    <div class="row margin10T ">
        <div class="col-lg-6 col-md-6 col-sm-12">
            <div id="TabDiv" class="stripeMeCS hugetable maxHeightD scrollbar-outer font-normal">
                <table id="tablist" border="0" cellspacing="0" cellpadding="0" width="100%">
                    <thead>
                        <tr>
                            <th nowrap>計畫進度</th>
                            <th nowrap>序號</th>
                            <th nowrap>計畫類別</th>
                            <th nowrap>主導廠商</th>
                            <th nowrap>聯合提案廠商</th>
                            <th nowrap>計畫名稱</th>
                            <th nowrap>應用服務別</th>
                            <th nowrap>服務實施場域</th>
                            <th nowrap>計畫總經費(千元)</th>
                            <th nowrap>計畫補助款(千元)</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div><!-- col -->
        <div class="col-lg-6 col-md-6 col-sm-12">
            <div id="ServiceTypePei" class="maxWithA"></div>
        </div><!-- col -->
    </div><!-- row -->
</asp:Content>
