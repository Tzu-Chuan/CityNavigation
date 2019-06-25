<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="CityInfoTable.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.CityInfoTable" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            //取得get參數
            if ($.getQueryString("city") == "") {
                location.href = "CityInfo.aspx";
                return;
            }
            else {
                if (Number($.getQueryString("city")) == 0 || Number($.getQueryString("city")) > 22) {
                    location.href = "CityInfo.aspx";
                    return;
                }
                else if (!$.isNumeric($.getQueryString("city"))) {
                    location.href = "CityInfo.aspx";
                    return;
                }
            }

            // 設定Tab CSS
            $("#" + $.getQueryString("listname")).addClass("SlimTabBtnV2Current");
            
            switch ($.getQueryString("listname")) {
                case "Population"://人口土地
                    getPopulationList();
                    break;
                case "Travel"://觀光
                    getTravelList();
                    break;
                case "Traffic"://交通
                    getTrafficList();
                    break;
                case "Farming"://農業
                    getFarmingList();
                    break;
                case "Industry"://產業
                    getIndustryList();
                    break;
                case "Retail"://零售
                    getRetailList();
                    break;
                case "Safety"://智慧安全、治理
                    getSafetyList();
                    break;
                case "Energy"://能源
                    getEnergyList();
                    break;
                case "Health"://健康
                    getHealthList();
                    break;
                case "Education"://教育
                    getEducationList();
                    break;
                default:
                    location.href = "CityInfo.aspx";
            }
            
            $(document).on("click", "a[name='linkbtn']", function () {
                location.href = "CityInfoTable.aspx?city=" + $.getQueryString("city") + "&listname=" + $(this).attr("category");
            });
        })// js end
        

        //撈人口土地列表
        function getPopulationList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
                data: {
                    CityNo: $.getQueryString("city")
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap"><a href="Population_All.aspx">年底戶籍總人口數</a></td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_TotalYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("P_PeopleTotal", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                            tabstr += '<tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">年底戶籍總人口數成長率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_PeopleTotalPercentYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_PeopleTotalPercent", data).text().trim()).toFixed(0)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">0-14歲幼年人口數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_Year", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_PeopleTotalPercent", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">0-14歲幼年人口比例</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_Year", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_ChildPercent", data).text().trim()).toFixed(0)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">15-64歲青壯年人口數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_Year", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_Teenager", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">15-64歲青壯年人口比例</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_Year", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_TeenagerPercent", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">65歲以上老年人口數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_Year", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_OldMen", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">65歲以上歲老年人口比例</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_Year", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_OldMenPercent", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                          
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">土地面積</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_AreaYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_Area", data).text().trim()).toFixed(2)) + 'km<sup>2</sup>' + '</td>';
                            tabstr += '</td></tr>';
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        
                        $("#Table_list tbody").empty();
                        $("#Table_list tbody").append(tabstr);
                    }
                }
            });
        }

        //撈觀光列表
        function getTravelList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTravelList.aspx",
                data: {
                    CityNo: $.getQueryString("city")
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">觀光旅館住用率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("T_HotelUseYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("T_HotelUseRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">觀光遊憩據點(縣市)人次統計</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("T_PointYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("T_PointPeople", data).text().trim()).toFixed(0)) + '人次' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">觀光旅館家數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("T_HotelsYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("T_Hotels", data).text().trim()).toFixed(0)) + '家' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">觀光旅館房間數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("T_HotelRoomsYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("T_HotelRooms", data).text().trim()).toFixed(0)) + '間' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">觀光旅館平均房價</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("T_HotelAvgPriceYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("T_HotelAvgPrice", data).text().trim()).toFixed(0)) + '元' + '</td>';
                            tabstr += '</td></tr>';
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        
                        $("#Table_list tbody").empty();
                        $("#Table_list tbody").append(tabstr);
                    }
                }
            });
        }

        //撈交通列表
        function getTrafficList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
                data: {
                    CityNo: $.getQueryString("city")
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Table_list tbody").empty();
                        var tabstr = '';
                        var tabstr1 = '';
                        var tabstr2 = '';
                        var tabstr3 = '';
                        var tabstr4 = '';
                        var tabstr5 = '';
                        var tabstr6 = '';
                        var tabstr7 = '';
                        var tabstr8 = '';

                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="left" nowrap="nowrap">通勤學民眾運具次數之公共運具市佔率</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_PublicTransportRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Tra_PublicTransportRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="left" nowrap="nowrap">自小客車在居家附近每次尋找停車位時間</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarParkTimeYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Tra_CarParkTime").text().trim()).toFixed(1)) + '分鐘' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="left" nowrap="nowrap">小汽車路邊及路外停車位</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarParkSpaceYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Tra_CarParkSpace").text().trim()).toFixed(0)) + '個' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="left" nowrap="nowrap">每萬輛小型車擁有路外及路邊停車位數</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_10KHaveCarParkYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Tra_10KHaveCarPark").text().trim()).toFixed(2)) + '位／萬輛' + '</td>';
                                tabstr3 += '</td></tr>';

                                tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr4 += '<td align="left" nowrap="nowrap">汽車登記數</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarCountYear").text().trim() + '年' + '</td>';
                                tabstr4 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Tra_CarCount").text().trim()).toFixed(0)) + '輛' + '</td>';
                                tabstr4 += '</td></tr>';

                                tabstr5 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr5 += '<td align="left" nowrap="nowrap">每百人擁有汽車數</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100HaveCarYear").text().trim() + '年' + '</td>';
                                tabstr5 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Tra_100HaveCar").text().trim()).toFixed(2)) + '輛' + '</td>';
                                tabstr5 += '</td></tr>';

                                tabstr6 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr6 += '<td align="left" nowrap="nowrap">每百人擁有汽車數成長率</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100HaveCarRateYearDec").text().trim() + '年' + '</td>';
                                tabstr6 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Tra_100HaveCarRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr6 += '</td></tr>';

                                tabstr7 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr7 += '<td align="left" nowrap="nowrap">每萬輛機動車肇事數</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_10KMotoIncidentsNumYear").text().trim() + '年' + '</td>';
                                tabstr7 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Tra_10KMotoIncidentsNum").text().trim()).toFixed(2)) + '次' + '</td>';
                                tabstr7 += '</td></tr>';

                                tabstr8 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr8 += '<td align="left" nowrap="nowrap">每十萬人道路交通事故死傷人數</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100KNumberOfCasualtiesYear").text().trim() + '年' + '</td>';
                                tabstr8 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Tra_100KNumberOfCasualties").text().trim()).toFixed(2)) + '人' + '</td>';
                                tabstr8 += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Table_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3 + tabstr4 + tabstr5 + tabstr6 + tabstr7 + tabstr8);
                    }
                }
            });
        }
        
        //撈農業列表
        function getFarmingList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
                data: {
                    CityNo: $.getQueryString("city")
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">臺閩地區農業天然災害產物損失</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Fa_FarmingLossYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("Fa_FarmingLoss", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">天然災害畜牧業產物損失</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Fa_AnimalLossYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Fa_AnimalLoss", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">天然災害漁業產物損失</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Fa_FishLossYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Fa_FishLoss", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">臺閩地區林業天然災害產物損失</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Fa_ForestLossYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Fa_ForestLoss", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">農林漁牧天然災害產物損失</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Fa_AllLossYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Fa_AllLoss", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">農林漁牧天然災害設施(備)損失</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Fa_FacilityLossYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Fa_FacilityLoss", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';
                           
                            var Fa_FarmingOutputValueYear_Str = $("Fa_FarmingOutputValue", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">農業產值</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Fa_FarmingOutputValueYear", data).text().trim() + '年' + '</td>';
                            if (Fa_FarmingOutputValueYear_Str != "─") {
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Fa_FarmingOutputValue", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            }
                            else {
                                tabstr += '<td align="right" nowrap="nowrap">' + $("Fa_FarmingOutputValue", data).text().trim() + '</td>';
                            }
                            tabstr += '</td></tr>';
                            
                            var Fa_FarmingOutputRate_Str = $("Fa_FarmingOutputRate", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">農業產值成長率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Fa_FarmingOutputRateYearDesc", data).text().trim() + '年' + '</td>';
                            if (Fa_FarmingOutputRate_Str != "─") {
                                    tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Fa_FarmingOutputRate", data).text().trim().text().trim()).toFixed(2)) + '%' + '</td>';
                                } else {
                                    tabstr += '<td align="right" nowrap="nowrap">' + $("Fa_FarmingOutputRate", data).text().trim() + '</td>';
                                }
                            tabstr += '</td></tr>';
                           
                            var Fa_Farmer_Str = $("Fa_Farmer", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">農戶人口數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Fa_FarmerYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($("Fa_Farmer", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            if (Fa_Farmer_Str != "─") {
                                    tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Fa_Farmer", data).text().trim()).toFixed(0)) + '人'+'</td>';
                                } else {
                                    tabstr += '<td align="right" nowrap="nowrap">' + $("Fa_Farmer", data).text().trim() + '人'+'</td>';
                                }
                            tabstr += '</td></tr>';

                            var Fa_FarmEmploymentOutputValue_Str = $("Fa_FarmEmploymentOutputValue", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">平均農業從業人口產值</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Fa_FarmEmploymentOutputValueYear", data).text().trim() + '年' + '</td>';
                            if (Fa_FarmEmploymentOutputValue_Str != "─") {
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Fa_FarmEmploymentOutputValue", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            }
                            else {
                                tabstr += '<td align="right" nowrap="nowrap">' + $("Fa_FarmEmploymentOutputValue", data).text().trim() + '</td>';
                            }
                            tabstr += '</td></tr>';
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        
                        $("#Table_list tbody").empty();
                        $("#Table_list tbody").append(tabstr);
                    }
                }
            });
        }
       
        //撈產業列表
        function getIndustryList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetIndustryList.aspx",
                data: {
                    CityNo: $.getQueryString("city")
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">形成群聚之產業(依工研院產科國際所群聚資料)</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ind_BusinessYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="center">' + $("Ind_Business", data).text().trim() + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">營運中工廠家數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ind_FactoryYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($("Ind_Factory", data).text().trim()).toFixed(0)) + '家' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">工廠營業收入</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ind_IncomeYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($("Ind_Income", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">營利事業銷售額</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ind_SalesYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($("Ind_Sales", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        
                        $("#Table_list tbody").empty();
                        $("#Table_list tbody").append(tabstr);
                    }
                }
            });
        }
        
        //撈零售列表
        //function getRetailList() {
        //    $.ajax({
        //        type: "POST",
        //        async: false, //在沒有返回值之前,不會執行下一步動作
        //        url: "../handler/GetRetailList.aspx",
        //        data: {
        //            CityNo: $.getQueryString("city")
        //        },
        //        error: function (xhr) {
        //            alert(xhr.responseText);
        //        },
        //        success: function (data) {
        //            if ($(data).find("Error").length > 0) {
        //                alert($(data).find("Error").attr("Message"));
        //            }
        //            else {
        //                var tabstr = '';
        //                if ($(data).find("data_item").length > 0) {
        //                    var Re_StreetStand = $("Re_StreetStand", data).text().trim();
        //                    tabstr += '<tr>';
        //                    tabstr += '<td align="left" nowrap="nowrap">攤販經營家數</td>';
        //                    tabstr += '<td align="center" nowrap="nowrap">' + $("Re_StreetStandYear", data).text().trim() + '年' + '</td>';
        //                    if (Re_StreetStand != "─") {
        //                        tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("Re_StreetStand", data).text().trim()).toFixed(2)) + '%床' + '</td>';
        //                    }
        //                    else {
        //                        tabstr += '<td align="right">' + $("Re_StreetStand", data).text().trim() + '</td>';
        //                    }
        //                    tabstr += '</td></tr>';
                           
        //                    var Re_StreetVendor = $("Re_StreetVendor", data).text().trim();
        //                    tabstr += '<tr>';
        //                    tabstr += '<td align="left" nowrap="nowrap">攤販從業人數</td>';
        //                    tabstr += '<td align="center" nowrap="nowrap">' + $("Re_Re_StreetVendorYear", data).text().trim() + '年' + '</td>';
        //                    if (Re_StreetVendor != "─") {
        //                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Re_StreetVendor", data).text().trim()).toFixed(0)) + '床' + '</td>';
        //                    }
        //                    else {
        //                        tabstr += '<td align="right" nowrap="nowrap">' + $("Re_StreetVendor", data).text().trim() + '</td>';
        //                    }
        //                    tabstr += '</td></tr>';

        //                    var Re_StreetVendorIncome = $("Re_StreetVendorIncome", data).text().trim();
        //                    tabstr += '<tr>';
        //                    tabstr += '<td align="left" nowrap="nowrap">攤販全年收入</td>';
        //                    tabstr += '<td align="center" nowrap="nowrap">' + $("Re_StreetVendorIncomeYear", data).text().trim() + '年' + '</td>';
        //                    if (Re_StreetVendorIncome != "─") {
        //                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Re_StreetVendorIncome", data).text().trim()).toFixed(0)) + '千元' + '</td>';
        //                    }
        //                    else {
        //                        tabstr += '<td align="right" nowrap="nowrap">' + $("Re_StreetVendorIncome", data).text().trim() + '</td>';
        //                    }
                            
        //                    tabstr += '</td></tr>';
        //                    //
                            
        //                        tabstr += '<tr>';
        //                        tabstr += '<td align="left" nowrap="nowrap"></td>';
        //                        tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_StreetVendorAvgIncomeYear").text().trim() + '年' + '</td>';
        //                        if (Re_StreetVendorAvgIncome != "─") {
        //                            tabstr3 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Re_StreetVendorAvgIncome").text().trim()).toFixed(0)) + '千元' + '</td>';

        //                        }
        //                        else {
        //                            tabstr3 += '<td align="right" nowrap="nowrap">' + $(this).children("Re_StreetVendorAvgIncome").text().trim() + '</td>';
        //                        }
        //                        tabstr3 += '</td></tr>';

        //                    var Re_StreetVendorAvgIncome = $("Hea_DisabledPersonOfCityRate", data).text().trim();
        //                    tabstr += '<tr>';
        //                    tabstr += '<td align="left" nowrap="nowrap">攤販全年平均收入</td>';
        //                    tabstr += '<td align="center" nowrap="nowrap">' + $("Re_StreetVendorAvgIncomeYear", data).text().trim() + '年' + '</td>';
        //                    if (Re_StreetVendorAvgIncome != "─") {
        //                        tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_DisabledPersonOfCityRate", data).text().trim()).toFixed(0)) + '千元%' + '</td>';
        //                    }
        //                    else {
        //                        tabstr += '<td align="right" nowrap="nowrap">' + $("Hea_DisabledPersonOfCityRate", data).text().trim() + '</td>';
        //                    }
                            
        //                    tabstr += '</td></tr>';
        //                    //
        //                    tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
        //                        tabstr4 += '<td align="left" nowrap="nowrap">零售業營利事業銷售額</td>';
        //                        tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_RetailBusinessSalesYear").text().trim() + '年' + '</td>';
        //                        tabstr4 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Re_RetailBusinessSales").text().trim()).toFixed(0)) + '千元' + '</td>';
        //                        tabstr4 += '</td></tr>';

        //                    tabstr += '<tr>';
        //                    tabstr += '<td align="left" nowrap="nowrap">長期照顧機構可供進駐人數</td>';
        //                    tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_LongTermPersonYear", data).text().trim() + '年' + '</td>';
        //                    tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_LongTermPerson", data).text().trim()).toFixed(2)) + '人' + '</td>';
        //                    tabstr += '</td></tr>';
        //                    //
        //                    tabstr5 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
        //                        tabstr5 += '<td align="left" nowrap="nowrap">零售業營利事業銷售額成長率</td>';
        //                        tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_RetailBusinessSalesRateYearDesc").text().trim() + '</td>';
        //                        tabstr5 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Re_RetailBusinessSalesRate").text().trim()).toFixed(2)) + '%' + '</td>';
        //                        tabstr5 += '</td></tr>';

        //                    tabstr += '<tr>';
        //                    tabstr += '<td align="left" nowrap="nowrap">長期照顧機構可供進駐人數佔預估失能老人需求比例</td>';
        //                    tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_LongTermPersonOfOldMenRateYear", data).text().trim() + '年' + '</td>';
        //                    tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_LongTermPersonOfOldMenRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
        //                    tabstr += '</td></tr>';
        //                    //
        //                    tabstr6 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
        //                        tabstr6 += '<td align="left" nowrap="nowrap">零售業營利事業平均每家銷售額</td>';
        //                        tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_RetailBusinessAvgSalesYear").text().trim() + '年' + '</td>';
        //                        tabstr6 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Re_RetailBusinessAvgSales").text().trim()).toFixed(2)) + '千元' + '</td>';
        //                    tabstr6 += '</td></tr>';

        //                    tabstr += '<tr>';
        //                    tabstr += '<td align="left" nowrap="nowrap">醫療機構數</td>';
        //                    tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_MedicalInstitutionsYear", data).text().trim() + '年' + '</td>';
        //                    tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_MedicalInstitutions", data).text().trim()).toFixed(0)) + '所' + '</td>';
        //                    tabstr += '</td></tr>';
                           
        //                }
        //                else
        //                    tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        
        //                $("#Table_list tbody").empty();
        //                $("#Table_list tbody").append(tabstr);
        //            }
        //        }
        //    });
        //}
        
        //撈智慧安全、治理列表
        function getSafetyList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
                data: {
                    CityNo: $.getQueryString("city")
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Table_list tbody").empty();
                        var tabstr = '';
                        var tabstr1 = '';
                        var tabstr2 = '';
                        var tabstr3 = '';
                        var tabstr4 = '';
                        var tabstr5 = '';
                        var tabstr6 = '';
                        var tabstr7 = '';
                        var tabstr8 = '';
                        var tabstr9 = '';

                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="left" nowrap="nowrap">土壤污染控制場址面積</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_SoilAreaYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Sf_SoilArea").text().trim()).toFixed(0)) + '平方公尺' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="left" nowrap="nowrap">地下水受污染使用限制面積</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_UnderWaterAreaYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Sf_UnderWaterArea").text().trim()).toFixed(0)) + '平方公尺' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="left" nowrap="nowrap">總懸浮微粒排放量</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_PM25QuantityYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Sf_PM25Quantity").text().trim()).toFixed(2)) + '公噸' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="left" nowrap="nowrap">每萬人火災發生次數</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_10KPeopleFireTimesYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Sf_10KPeopleFireTimes").text().trim()).toFixed(2)) + '次' + '</td>';
                                tabstr3 += '</td></tr>';

                                tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr4 += '<td align="left" nowrap="nowrap">每十萬人竊盜案發生數</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleBurglaryTimesYear").text().trim() + '年' + '</td>';
                                tabstr4 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Sf_100KPeopleBurglaryTimes").text().trim()).toFixed(2)) + '件' + '</td>';
                                tabstr4 += '</td></tr>';

                                tabstr5 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr5 += '<td align="left" nowrap="nowrap">竊盜案破獲率</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_BurglaryClearanceRateYear").text().trim() + '</td>';
                                tabstr5 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Sf_BurglaryClearanceRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr5 += '</td></tr>';

                                tabstr6 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr6 += '<td align="left" nowrap="nowrap">每十萬人刑案發生數</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleCriminalCaseTimesYear").text().trim() + '年' + '</td>';
                                tabstr6 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Sf_100KPeopleCriminalCaseTimes").text().trim()).toFixed(2)) + '件' + '</td>';
                                tabstr6 += '</td></tr>';

                                tabstr7 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr7 += '<td align="left" nowrap="nowrap">刑案破獲率</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CriminalCaseClearanceRateYear").text().trim() + '年' + '</td>';
                                tabstr7 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Sf_CriminalCaseClearanceRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr7 += '</td></tr>';

                                tabstr8 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr8 += '<td align="left" nowrap="nowrap">每十萬人暴力犯罪發生數</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleViolentCrimesTimesYear").text().trim() + '年' + '</td>';
                                tabstr8 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Sf_100KPeopleViolentCrimesTimes").text().trim()).toFixed(2)) + '件' + '</td>';
                                tabstr8 += '</td></tr>';

                                tabstr9 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr9 += '<td align="left" nowrap="nowrap">暴力犯罪破獲率</td>';
                                tabstr9 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_ViolentCrimesClearanceRateYear").text().trim() + '年' + '</td>';
                                tabstr9 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Sf_ViolentCrimesClearanceRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr9 += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Table_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3 + tabstr4 + tabstr5 + tabstr6 + tabstr7 + tabstr8 + tabstr9);
                    }
                }
            });
        }

        //撈能源列表
        function getEnergyList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEnergyList.aspx",
                data: {
                    CityNo: $.getQueryString("city")
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Table_list tbody").empty();
                        var tabstr = '';
                        var tabstr1 = '';
                        var tabstr2 = '';
                        var tabstr3 = '';

                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="left" nowrap="nowrap">再生能源裝置容量數</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_DeviceCapacityNumYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Ene_DeviceCapacityNum").text().trim()).toFixed(0)) + '千瓦' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="left" nowrap="nowrap">台電購入再生能源電量</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_TPCBuyElectricityYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Ene_TPCBuyElectricity").text().trim()).toFixed(0)) + '度' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="left" nowrap="nowrap">用電量</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_ElectricityUsedYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Ene_ElectricityUsed").text().trim()).toFixed(0)) + '度' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="left" nowrap="nowrap">再生能源電量佔用電量比例</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_ReEnergyOfElectricityRateYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Ene_ReEnergyOfElectricityRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr3 += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Table_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3);
                    }
                }
            });
        }
        
        //撈健康列表
        function getHealthList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
                data: {
                    CityNo: $.getQueryString("city")
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每萬人口病床數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_10KPeopleBedYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("Hea_10KPeopleBed", data).text().trim()).toFixed(2)) + '%床' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每萬人口急性一般病床數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_10KPeopleAcuteGeneralBedYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_10KPeopleAcuteGeneralBed", data).text().trim()).toFixed(0)) + '床' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每萬人執業醫事人員數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_10KpeoplePractitionerYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_10KpeoplePractitioner", data).text().trim()).toFixed(2)) + '人' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">身心障礙人口占全縣(市)總人口比率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_DisabledPersonOfCityRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_DisabledPersonOfCityRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">長期照顧機構可供進駐人數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_LongTermPersonYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_LongTermPerson", data).text().trim()).toFixed(2)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">長期照顧機構可供進駐人數佔預估失能老人需求比例</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_LongTermPersonOfOldMenRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_LongTermPersonOfOldMenRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">醫療機構數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_MedicalInstitutionsYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_MedicalInstitutions", data).text().trim()).toFixed(0)) + '所' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">平均每一醫療機構服務人數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_MedicalInstitutionsAvgPersonYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_MedicalInstitutionsAvgPerson", data).text().trim()).toFixed(0)) + '人/所' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">政府部門醫療保健支出</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_GOVPayOfNHIYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_GOVPayOfNHI", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';
                        }
                        else
                            tabstr += '<tr><td colspan="3">查詢無資料</td></tr>';
                        
                        $("#Table_list tbody").empty();
                        $("#Table_list tbody").append(tabstr);
                    }
                }
            });
        }
        
        //撈教育列表
        function getEducationList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
                data: {
                    CityNo: $.getQueryString("city")
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Table_list tbody").empty();
                        var tabstr = '';
                        var tabstr1 = '';
                        var tabstr2 = '';
                        var tabstr3 = '';
                        var tabstr4 = '';
                        var tabstr5 = '';
                        var tabstr6 = '';
                        var tabstr7 = '';
                        var tabstr8 = '';
                        var tabstr9 = '';
                        var tabstr10 = '';
                        var tabstr11 = '';
                        var tabstr12 = '';
                        var tabstr13 = '';
                        var tabstr14 = '';
                        var tabstr15 = '';
                        var tabstr16 = '';
                        var tabstr17 = '';
                        var tabstr18 = '';

                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="left" nowrap="nowrap">15歲以上民間人口之教育程度結構-國中及以下</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upJSDownRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_15upJSDownRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="left" nowrap="nowrap">15歲以上民間人口之教育程度結構-高中(職)</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upHSRateYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_15upHSRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="left" nowrap="nowrap">15歲以上民間人口之教育程度結構-大專及以上</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upUSUpRateYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_15upUSUpRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="left" nowrap="nowrap">國小學生輟學率</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESStudentDropOutRateYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_ESStudentDropOutRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr3 += '</td></tr>';

                                tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr4 += '<td align="left" nowrap="nowrap">國中學生輟學率</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_JSStudentDropOutRateYear").text().trim() + '年' + '</td>';
                                tabstr4 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_JSStudentDropOutRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr4 += '</td></tr>';

                                tabstr5 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr5 += '<td align="left" nowrap="nowrap">國小總學生數</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESStudentsYear").text().trim() + '年' + '</td>';
                                tabstr5 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_ESStudents").text().trim()).toFixed(0)) + '人' + '</td>';
                                tabstr5 += '</td></tr>';

                                tabstr6 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr6 += '<td align="left" nowrap="nowrap">國中總學生數</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_JSStudentsYear").text().trim() + '年' + '</td>';
                                tabstr6 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_JSStudents").text().trim()).toFixed(0)) + '人' + '</td>';
                                tabstr6 += '</td></tr>';

                                tabstr7 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr7 += '<td align="left" nowrap="nowrap">高中(職)總學生數</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_HSStudentsYear").text().trim() + '年' + '</td>';
                                tabstr7 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_HSStudents").text().trim()).toFixed(0)) + '人' + '</td>';
                                tabstr7 += '</td></tr>';

                                tabstr8 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr8 += '<td align="left" nowrap="nowrap">國小-高中(職)原住民學生數</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSIndigenousYear").text().trim() + '年' + '</td>';
                                tabstr8 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_ESToHSIdigenous").text().trim()).toFixed(0)) + '人' + '</td>';
                                tabstr8 += '</td></tr>';

                                tabstr9 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr9 += '<td align="left" nowrap="nowrap">國小-高中(職)原住民學生數比例</td>';
                                tabstr9 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSIndigenousRateYear").text().trim() + '年' + '</td>';
                                tabstr9 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_ESToHSIndigenousRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr9 += '</td></tr>';

                                tabstr10 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr10 += '<td align="left" nowrap="nowrap">國中小新住民人數</td>';
                                tabstr10 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSNewInhabitantsYear").text().trim() + '年' + '</td>';
                                tabstr10 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_ESJSNewInhabitants").text().trim()).toFixed(0)) + '人' + '</td>';
                                tabstr10 += '</td></tr>';

                                tabstr11 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr11 += '<td align="left" nowrap="nowrap">國中小新住民學生比例</td>';
                                tabstr11 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSNewInhabitantsRateYear").text().trim() + '年' + '</td>';
                                tabstr11 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_ESToJSNewInhabitantsRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr11 += '</td></tr>';

                                tabstr12 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr12 += '<td align="left" nowrap="nowrap">國中小教師數</td>';
                                tabstr12 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSTeachersYear").text().trim() + '年' + '</td>';
                                tabstr12 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_ESJSTeachers").text().trim()).toFixed(0)) + '人' + '</td>';
                                tabstr12 += '</td></tr>';

                                tabstr13 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr13 += '<td align="left" nowrap="nowrap">國中小生師比(平均每位教師教導學生數)</td>';
                                tabstr13 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSTeachersOfStudentRateYear").text().trim() + '年' + '</td>';
                                tabstr13 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_ESJSTeachersOfStudentRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr13 += '</td></tr>';

                                tabstr14 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr14 += '<td align="left" nowrap="nowrap">教育預算</td>';
                                tabstr14 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_BudgetYear").text().trim() + '年' + '</td>';
                                tabstr14 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_Budget").text().trim()).toFixed(0)) + '千元' + '</td>';
                                tabstr14 += '</td></tr>';

                                tabstr15 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr15 += '<td align="left" nowrap="nowrap">教育預算成長率</td>';
                                tabstr15 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_BudgetUpRateYearDesc").text().trim() + '年' + '</td>';
                                tabstr15 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_BudgetUpRate").text().trim()).toFixed(2)) + '%' + '</td>';
                                tabstr15 += '</td></tr>';

                                tabstr16 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr16 += '<td align="left" nowrap="nowrap">國小-高中(職)平均每人教育預算</td>';
                                tabstr16 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSAvgBudgetYear").text().trim() + '年' + '</td>';
                                tabstr16 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_ESToHSAvgBudget").text().trim()).toFixed(0)) + '千元' + '</td>';
                                tabstr16 += '</td></tr>';

                                tabstr17 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr17 += '<td align="left" nowrap="nowrap">國中小教學電腦數</td>';
                                tabstr17 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSPCNumYear").text().trim() + '年' + '</td>';
                                tabstr17 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_ESJSPCNum").text().trim()).toFixed(0)) + '台' + '</td>';
                                tabstr17 += '</td></tr>';

                                tabstr18 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr18 += '<td align="left" nowrap="nowrap">國中小平均每人教學電腦數</td>';
                                tabstr18 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSAvgPCNumYear").text().trim() + '年' + '</td>';
                                tabstr18 += '<td align="right" nowrap="nowrap">' + FormatNumber(Number($(this).children("Edu_ESJSAvgPCNum").text().trim()).toFixed(2)) + '台' + '</td>';
                                tabstr18 += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Table_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3 + tabstr4 + tabstr5 + tabstr6 + tabstr7 + tabstr8 + tabstr9 + tabstr10 + tabstr11 + tabstr12 + tabstr13 + tabstr14 + tabstr15 + tabstr16 + tabstr17 + tabstr18);
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
    <div class="WrapperBody" id="WrapperBody">
        <div class="container margin15T" id="ContentWrapper">

            <div class="twocol titleLineA">
                <div class="left"><span class="font-size4"><%= CityName %></span></div>
                <!-- left -->
                <div class="right"><%--首頁 / 桃園市 / 桃園市人口--%></div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div class="tabmenublockV2wrapper margin10T">
                <div class="tabmenublockV2">
                    <span class="SlimTabBtnV2" id="Population"><a name="linkbtn" category="Population" href="javascript:void(0)" target="_self">人口土地</a></span>
                    <span class="SlimTabBtnV2" id="Industry"><a name="linkbtn" category="Industry" href="javascript:void(0)" target="_self">產業</a></span>
                    <span class="SlimTabBtnV2" id="Farming"><a name="linkbtn" category="Farming" href="javascript:void(0)" target="_self">農業</a></span>
                    <span class="SlimTabBtnV2" id="Travel"><a name="linkbtn" category="Travel" href="javascript:void(0)" target="_self">觀光</a></span>
                    <span class="SlimTabBtnV2" id="Health"><a name="linkbtn" category="Health" href="javascript:void(0)" target="_self">健康</a></span>
                    <span class="SlimTabBtnV2" id="Retail"><a name="linkbtn" category="Retail" href="javascript:void(0)" target="_self">零售</a></span>
                    <span class="SlimTabBtnV2" id="Education"><a name="linkbtn" category="Education" href="javascript:void(0)" target="_self">教育</a></span>
                    <span class="SlimTabBtnV2" id="Traffic"><a name="linkbtn" category="Traffic" href="javascript:void(0)" target="_self">交通</a></span>
                    <span class="SlimTabBtnV2" id="Energy"><a name="linkbtn" category="Energy" href="javascript:void(0)" target="_self">能源</a></span>
                    <span class="SlimTabBtnV2" id="Safety"><a name="linkbtn" category="Safety" href="javascript:void(0)" target="_self">智慧安全、治理</a></span>
                </div>
                <!-- tabmenublock -->
            </div>
            <!-- tabmenublockV2wrapper -->

            <div class="stripeMeCS margin10T font-normal" id="Wrapper">
                <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Table_list">
                    <thead>
                        <tr>
                            <th>項目</th>
                            <th>資料年度</th>
                            <th>統計數據</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    <!--magpopup -->
</asp:Content>
