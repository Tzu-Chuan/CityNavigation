<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="CityPlanList.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.CityPlanList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            /// 表頭排序設定
            Page.Option.SortMethod = "+";
            Page.Option.SortName = "";

            getddl("02", "#ddlCity")
            ddl_ServiceType();
            
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

            $(document).on("click", "#SearchBtn", function () {
                Page.Option.SortName = "";
                getData();
            });
        });

        function getData() {
            $.ajax({
                type: "POST",
                async: true, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPlanList.aspx",
                data: {
                    City: $("#ddlCity").val(),
                    ServiceType: $("#ddlServiceType").val(),
                    PlanName: $("#strPlan").val(),
                    CompanyName: $("#strCompany").val(),
                    SortName: Page.Option.SortName,
                    SortMethod: Page.Option.SortMethod
                },
                beforeSend: function () {
                    $("#tablist thead").hide();
                    $("#tablist tbody").hide();
                    $(".DataDiv").show();
                    $("#TabDiv").loading({
                        message: "資料讀取中，請稍後"
                    });
                },
                complete: function () {
                    $("#tablist thead").show();
                    $("#tablist tbody").show();
                    $("#TabDiv").loading("stop");
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
                            if ($("#ddlCity").val() == "") {
                                $("#Total").show();
                                $("#ByOne").hide();
                                $(data).find("data_item").each(function (i) {
                                    tabstr += '<tr>';
                                    tabstr += '<td nowrap align="center">' + $(this).children("CS_PlanSchedule").text().trim() + '</td>';
                                    tabstr += '<td nowrap align="center">' + $(this).children("CS_No").text().trim() + '</td>';
                                    tabstr += '<td nowrap align="center">' + $(this).children("CS_PlanType").text().trim() + '</td>';
                                    tabstr += '<td nowrap align="center">' + $(this).children("CS_HostCompany").text().trim() + '</td>';
                                    tabstr += '<td align="center">' + $(this).children("CS_JointCompany").text().trim() + '</td>';
                                    tabstr += '<td nowrap align="center">' + $(this).children("CS_PlanName").text().trim() + '</td>';
                                    tabstr += '<td nowrap align="center">' + $(this).children("CS_ServiceType").text().trim() + '</td>';
                                    tabstr += '<td align="center">' + $(this).children("CS_CityArea").text().trim() + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_PlanTotalMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_PlanSubMoney").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_NewTaipei_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Taipei_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Taoyuan_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Taichung_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Tainan_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Kaohsiung_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Yilan_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_HsinchuCounty_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Miaoli_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Changhua_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Nantou_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Yunlin_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_ChiayiCounty_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Pingtung_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Taitung_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Hualien_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Penghu_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Keelung_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_HsinchuCity_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_ChiayiCity_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Kinmen_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Lienchiang_Total").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_NewTaipei_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Taipei_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Taoyuan_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Taichung_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Tainan_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Kaohsiung_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Yilan_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_HsinchuCounty_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Miaoli_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Changhua_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Nantou_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Yunlin_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_ChiayiCounty_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Pingtung_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Taitung_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Hualien_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Penghu_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Keelung_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_HsinchuCity_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_ChiayiCity_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Kinmen_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '<td nowrap align="right">' + FormatNumber(Number($(this).children("CS_Lienchiang_Sub").text().trim()).toFixed(0)) + '</td>';
                                    tabstr += '</tr>';
                                });
                            }
                            else {
                                $("#Total").hide();
                                $("#ByOne").show();
                                // 刪除動態的欄位
                                if ($("#ByOne th").length > 10) {
                                    $("#ByOne th[name='newth']").remove();
                                }
                                // 動態增加各縣市的表頭欄位
                                var CityStr = data.querySelector("CP_City").textContent;
                                $("#ByOne").append('<th nowrap name="newth">投入' + CityStr + '總經費(千元)</th><th nowrap name="newth">投入' + CityStr + '補助款(千元)</th>');
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
                            }
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

        // ddl 領域別
        function ddl_ServiceType() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetServiceTypeDDL.aspx",
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        var ddlstr = '<option value="">請選擇</option>';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                ddlstr += '<option value="' + $(this).children("CS_ServiceType").text().trim() + '">' + $(this).children("CS_ServiceType").text().trim() + '</option>';
                            });
                            $("#ddlServiceType").empty();
                            $("#ddlServiceType").append(ddlstr);
                        }
                    }
                }
            });
        }

        // ddl 縣市
        function getddl(gno, tagName) {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetDDL.aspx",
                data: {
                    Group: gno
                },
                error: function (xhr) {
                    alert("Error " + xhr.status);
                    console.log(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        var ddlstr = '<option value="">請選擇</option>';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                ddlstr += '<option value="' + $(this).children("C_Item").text().trim() + '">' + $(this).children("C_Item_cn").text().trim() + '</option>';
                            });
                            $(tagName).empty();
                            $(tagName).append(ddlstr);
                        }
                    }
                }
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
        <div class="left"><span class="font-size4">計畫查詢</span></div><!-- left -->
        <div class="right">首頁 / 智慧城鄉計畫提案 / 計畫查詢</div><!-- right -->
    </div><!-- twocol -->

    <div class="tabmenublockV2wrapper margin10T">
        <div class="tabmenublockV2 font-size3">
            <span class="SlimTabBtnV2 SlimTabBtnV2Current"><a href="javascript:void(0);" target="_self">補助經費區域分析(含全區)</a></span>
            <span class="SlimTabBtnV2"><a href="javascript:void(0);" target="_self">補助經費區域分析(不含全區)</a></span>
        </div><!-- tabmenublock -->
    </div><!-- tabmenublockV2wrapper -->

    <div class="BoxBgA BoxBorderA BoxRadiusB BoxShadowA margin10T padding10ALL">
        <div class="OchiFixTable width100 TitleLength05">
            <div class="OchiRow">
                <div class="OchiHalf">
                    <div class="OchiCell OchiTitle TitleSetWidth">所屬縣市</div>
                    <div class="OchiCell width100"><select id="ddlCity" class="width99 inputex"></select></div>
                </div><!-- OchiHalf -->
                <div class="OchiHalf">
                    <div class="OchiCell OchiTitle TitleSetWidth">領域別</div>
                    <div class="OchiCell width100"><select id="ddlServiceType" class="width99 inputex"></select></div>
                </div><!-- OchiHalf -->
            </div><!-- OchiRow -->

            <div class="OchiRow">
                <div class="OchiHalf">
                    <div class="OchiCell OchiTitle TitleSetWidth">計畫名稱</div>
                    <div class="OchiCell width100"><input id="strPlan" type="text" class="width99 inputex"> </div>
                </div><!-- OchiHalf -->
                <div class="OchiHalf">
                    <div class="OchiCell OchiTitle TitleSetWidth">公司名稱</div>
                    <div class="OchiCell width100"><input id="strCompany" type="text" class="width99 inputex"> </div>
                </div><!-- OchiHalf -->
            </div><!-- OchiRow -->
        </div><!-- OchiFixTable -->

        <div class="textright margin10T">
            <a id="SearchBtn" href="javascript:void(0);" class="genbtn">查詢</a>
        </div>
    </div><!-- Box -->

    <div class="font-size3 margin10T DataDiv" style="display:none;">詳細資料</div>
    <div id="TabDiv" class="stripeMeCS hugetable  font-normal margin5T margin10B maxHeightD">
        <table id="tablist" border="0" cellspacing="0" cellpadding="0" width="100%">
            <thead>
                <tr id="Total" style="display:none;">
                    <th nowrap>計畫進度</th>
                    <th nowrap>序號</th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CS_PlanType">計畫類別</a></th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CS_HostCompany">主導廠商</a></th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CS_JointCompany">聯合提案廠商</a></th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CS_PlanName">計畫名稱</a></th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CS_ServiceType">應用服務別</a></th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CS_CityArea">服務實施場域</a></th>
                    <th nowrap>計畫總經費(千元)</th>
                    <th nowrap>計畫補助款(千元)</th>
                    <th nowrap>投入新北市總經費(千元)</th>
                    <th nowrap>投入台北市總經費(千元)</th>
                    <th nowrap>投入桃園市總經費(千元)</th>
                    <th nowrap>投入台中市總經費(千元)</th>
                    <th nowrap>投入台南市總經費(千元)</th>
                    <th nowrap>投入高雄市總經費(千元)</th>
                    <th nowrap>投入宜蘭縣總經費(千元)</th>
                    <th nowrap>投入新竹縣總經費(千元)</th>
                    <th nowrap>投入苗栗縣總經費(千元)</th>
                    <th nowrap>投入彰化縣總經費(千元)</th>
                    <th nowrap>投入南投縣總經費(千元)</th>
                    <th nowrap>投入雲林縣總經費(千元)</th>
                    <th nowrap>投入嘉義縣總經費(千元)</th>
                    <th nowrap>投入屏東縣總經費(千元)</th>
                    <th nowrap>投入台東縣總經費(千元)</th>
                    <th nowrap>投入花蓮縣總經費(千元)</th>
                    <th nowrap>投入澎湖縣總經費(千元)</th>
                    <th nowrap>投入基隆市總經費(千元)</th>
                    <th nowrap>投入新竹市總經費(千元)</th>
                    <th nowrap>投入嘉義市總經費(千元)</th>
                    <th nowrap>投入金門縣總經費(千元)</th>
                    <th nowrap>投入連江縣總經費(千元)</th>
                    <th nowrap>投入新北市補助款(千元)</th>
                    <th nowrap>投入台北市補助款(千元)</th>
                    <th nowrap>投入桃園市補助款(千元)</th>
                    <th nowrap>投入台中市補助款(千元)</th>
                    <th nowrap>投入台南市補助款(千元)</th>
                    <th nowrap>投入高雄市補助款(千元)</th>
                    <th nowrap>投入宜蘭縣補助款(千元)</th>
                    <th nowrap>投入新竹縣補助款(千元)</th>
                    <th nowrap>投入苗栗縣補助款(千元)</th>
                    <th nowrap>投入彰化縣補助款(千元)</th>
                    <th nowrap>投入南投縣補助款(千元)</th>
                    <th nowrap>投入雲林縣補助款(千元)</th>
                    <th nowrap>投入嘉義縣補助款(千元)</th>
                    <th nowrap>投入屏東縣補助款(千元)</th>
                    <th nowrap>投入台東縣補助款(千元)</th>
                    <th nowrap>投入花蓮縣補助款(千元)</th>
                    <th nowrap>投入澎湖縣補助款(千元)</th>
                    <th nowrap>投入基隆市補助款(千元)</th>
                    <th nowrap>投入新竹市補助款(千元)</th>
                    <th nowrap>投入嘉義市補助款(千元)</th>
                    <th nowrap>投入金門縣補助款(千元)</th>
                    <th nowrap>投入連江縣補助款(千元)</th>
                </tr>
                <tr id="ByOne" style="display:none;">
                    <th nowrap>計畫進度</th>
                    <th nowrap>序號</th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CP_PlanType">計畫類別</a></th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CP_HostCompany">主導廠商</a></th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CP_JointCompany">聯合提案廠商</a></th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CP_PlanName">計畫名稱</a></th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CP_ServiceType">應用服務別</a></th>
                    <th nowrap><a href="javascript:void(0);" name="sortbtn" sortname="CP_CityArea">服務實施場域</a></th>
                    <th nowrap>計畫總經費(千元)</th>
                    <th nowrap>計畫補助款(千元)</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</asp:Content>
