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
                    CityNo: $.getQueryString("city"),
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap"><a href="Population_All.aspx">年底戶籍總人口數</a></td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_TotalYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("P_PeopleTotal", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                            tabstr += '<tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">年底戶籍總人口數成長率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_PeopleTotalPercentYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_PeopleTotalPercent", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">0-14歲幼年人口數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_ChildYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_Child", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">0-14歲幼年人口比例</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_ChildPercentYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_ChildPercent", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">15-64歲青壯年人口數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_TeenagerYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_Teenager", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">15-64歲青壯年人口比例</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_TeenagerPercentYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_TeenagerPercent", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">65歲以上老年人口數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_OldMenYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("P_OldMen", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">65歲以上歲老年人口比例</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("P_OldMenPercentYear", data).text().trim() + '年' + '</td>';
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
                    CityNo: $.getQueryString("city"),
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
                            var T_HotelUseRate = $("T_HotelUseRate", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">觀光旅館住用率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("T_HotelUseYear", data).text().trim() + '年' + '</td>';
                            if (T_HotelUseRate != "─") {
                                tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("T_HotelUseRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            }
                            else {
                                tabstr += '<td align="right">' + $("T_HotelUseRate", data).text().trim() + '</td>';
                            }
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">觀光遊憩據點(縣市)人次統計</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("T_PointYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("T_PointPeople", data).text().trim()).toFixed(0)) + '人次' + '</td>';
                            tabstr += '</td></tr>';
                            
                            var T_Hotels = $("T_Hotels", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">觀光旅館家數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("T_HotelsYear", data).text().trim() + '年' + '</td>';
                            if (T_Hotels != "─") {
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("T_Hotels", data).text().trim()).toFixed(0)) + '家' + '</td>';
                            }
                            else {
                                tabstr += '<td align="right">' + $("T_Hotels", data).text().trim() + '</td>';
                            }
                            tabstr += '</td></tr>';
                            
                            var T_HotelRooms = $("T_HotelRooms", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">觀光旅館房間數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("T_HotelRoomsYear", data).text().trim() + '年' + '</td>';
                            if (T_HotelRooms != "─") {
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("T_HotelRooms", data).text().trim()).toFixed(0)) + '間' + '</td>';
                            }
                            else {
                                tabstr += '<td align="right">' + $("T_HotelRooms", data).text().trim() + '</td>';
                            }
                            
                            tabstr += '</td></tr>';

                            var T_HotelAvgPrice = $("T_HotelAvgPrice", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">觀光旅館平均房價</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("T_HotelAvgPriceYear", data).text().trim() + '年' + '</td>';
                            if (T_HotelAvgPrice != "─") {
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("T_HotelAvgPrice", data).text().trim()).toFixed(0)) + '元' + '</td>';
                            }
                            else {
                                tabstr += '<td align="right">' + $("T_HotelAvgPrice", data).text().trim() + '</td>';
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
        
        //撈交通列表
        function getTrafficList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
                data: {
                    CityNo: $.getQueryString("city"),
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">通勤學民眾運具次數之公共運具市佔率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Tra_PublicTransportRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("Tra_PublicTransportRate", data).text().trim()).toFixed(1)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">自小客車在居家附近每次尋找停車位時間</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Tra_CarParkTimeYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Tra_CarParkTime", data).text().trim()).toFixed(1)) + '分鐘' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">小汽車路邊及路外停車位</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Tra_CarParkSpaceYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Tra_CarParkSpace", data).text().trim()).toFixed(0)) + '個' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每萬輛小型車擁有路外及路邊停車位數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Tra_10KHaveCarParkYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Tra_10KHaveCarPark", data).text().trim()).toFixed(2)) + '位／萬輛' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">汽車登記數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Tra_CarCountYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Tra_CarCount", data).text().trim()).toFixed(0)) + '輛' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每百人擁有汽車數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Tra_100HaveCarYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Tra_100HaveCar", data).text().trim()).toFixed(1)) + '輛' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每百人擁有汽車數成長率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Tra_100HaveCarRateYearDec", data).text().trim() + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Tra_100HaveCarRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每萬輛機動車肇事數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Tra_10KMotoIncidentsNumYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Tra_10KMotoIncidentsNum", data).text().trim()).toFixed(2)) + '次' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每十萬人道路交通事故死傷人數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Tra_100KNumberOfCasualtiesYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Tra_100KNumberOfCasualties", data).text().trim()).toFixed(2)) + '人' + '</td>';
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
        
        //撈農業列表
        function getFarmingList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
                data: {
                    CityNo: $.getQueryString("city"),
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
                                    tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Fa_FarmingOutputRate", data).text().trim()).toFixed(2)) + '%'+'</td>';
                                } else {
                                    tabstr += '<td align="right" nowrap="nowrap">' + $("Fa_FarmingOutputRate", data).text().trim() + '</td>';
                                }
                            tabstr += '</td></tr>';

                            var Fa_Farmer_Str = $("Fa_Farmer", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">農戶人口數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Fa_FarmerYear", data).text().trim() + '年' + '</td>';
                            if (Fa_Farmer_Str != "─") {
                                    tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Fa_Farmer", data).text().trim()).toFixed(0)) + '人'+'</td>';
                                } else {
                                    tabstr += '<td align="right" nowrap="nowrap">' + $("Fa_Farmer", data).text().trim() + '</td>';
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
                    CityNo: $.getQueryString("city"),
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">形成群聚之產業(依工研院產科國際所群聚資料)</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ind_BusinessYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="center">' + $("Ind_Business", data).text().trim() + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">營運中工廠家數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ind_FactoryYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Ind_Factory", data).text().trim()).toFixed(0)) + '家' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">工廠營業收入</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ind_IncomeYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Ind_Income", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">營利事業銷售額</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ind_SalesYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Ind_Sales", data).text().trim()).toFixed(0)) + '千元' + '</td>';
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
        function getRetailList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetRetailList.aspx",
                data: {
                    CityNo: $.getQueryString("city"),
                    Token:$("#InfoToken").val()
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
                            var Re_StreetStand = $("Re_StreetStand", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">攤販經營家數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Re_StreetStandYear", data).text().trim() + '年' + '</td>';
                            if (Re_StreetStand != "─") {
                                tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("Re_StreetStand", data).text().trim()).toFixed(0)) + '家' + '</td>';
                            }
                            else {
                                tabstr += '<td align="right">' + $("Re_StreetStand", data).text().trim() + '</td>';
                            }
                            tabstr += '</td></tr>';
                           
                            var Re_StreetVendor = $("Re_StreetVendor", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">攤販從業人數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Re_Re_StreetVendorYear", data).text().trim() + '年' + '</td>';
                            if (Re_StreetVendor != "─") {
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Re_StreetVendor", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            }
                            else {
                                tabstr += '<td align="right" nowrap="nowrap">' + $("Re_StreetVendor", data).text().trim() + '</td>';
                            }
                            tabstr += '</td></tr>';

                            var Re_StreetVendorIncome = $("Re_StreetVendorIncome", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">攤販全年收入</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Re_StreetVendorIncomeYear", data).text().trim() + '年' + '</td>';
                            if (Re_StreetVendorIncome != "─") {
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Re_StreetVendorIncome", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            }
                            else {
                                tabstr += '<td align="right" nowrap="nowrap">' + $("Re_StreetVendorIncome", data).text().trim() + '</td>';
                            }
                            
                            tabstr += '</td></tr>';

                            var Re_StreetVendorAvgIncome = $("Re_StreetVendorAvgIncome", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">攤販全年平均收入</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Re_StreetVendorAvgIncomeYear", data).text().trim() + '年' + '</td>';
                            if (Re_StreetVendorAvgIncome != "─") {
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Re_StreetVendorAvgIncome", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            }
                            else {
                                tabstr += '<td align="right" nowrap="nowrap">' + $("Re_StreetVendorAvgIncome", data).text().trim() + '</td>';
                            }
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">零售業營利事業銷售額</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Re_RetailBusinessSalesYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Re_RetailBusinessSales", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">零售業營利事業銷售額成長率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Re_RetailBusinessSalesRateYearDesc", data).text().trim() + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Re_RetailBusinessSalesRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">零售業營利事業平均每家銷售額</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Re_RetailBusinessAvgSalesYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Re_RetailBusinessAvgSales", data).text().trim()).toFixed(2)) + '千元' + '</td>';
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
        
        //撈智慧安全、治理列表
        function getSafetyList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
                data: {
                    CityNo: $.getQueryString("city"),
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">土壤污染控制場址面積</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Sf_SoilAreaYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("Sf_SoilArea", data).text().trim()).toFixed(0)) + 'm<sup>2</sup>' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">地下水受污染使用限制面積</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Sf_UnderWaterAreaYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Sf_UnderWaterArea", data).text().trim()).toFixed(0)) + 'm<sup>2</sup>' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">總懸浮微粒排放量</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Sf_PM25QuantityYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Sf_PM25Quantity", data).text().trim()).toFixed(2)) + '公噸' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每萬人火災發生次數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Sf_10KPeopleFireTimesYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Sf_10KPeopleFireTimes", data).text().trim()).toFixed(2)) + '次' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每十萬人竊盜案發生數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Sf_100KPeopleBurglaryTimesYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Sf_100KPeopleBurglaryTimes", data).text().trim()).toFixed(2)) + '件' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">竊盜案破獲率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Sf_BurglaryClearanceRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Sf_BurglaryClearanceRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每十萬人刑案發生數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Sf_100KPeopleCriminalCaseTimesYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Sf_100KPeopleCriminalCaseTimes", data).text().trim()).toFixed(2)) + '件' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">刑案破獲率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Sf_CriminalCaseClearanceRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Sf_CriminalCaseClearanceRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';

                            var Sf_100KPeopleViolentCrimesTimes = $("Sf_100KPeopleViolentCrimesTimes", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每十萬人暴力犯罪發生數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Sf_100KPeopleViolentCrimesTimesYear", data).text().trim() + '年' + '</td>';
                            if (Sf_100KPeopleViolentCrimesTimes != "─") {
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Sf_100KPeopleViolentCrimesTimes", data).text().trim()).toFixed(2)) + '件' + '</td>';
                            }
                            else {
                                tabstr += '<td align="right" nowrap="nowrap">' + $("Sf_100KPeopleViolentCrimesTimes", data).text().trim(); + '</td>';
                            }
                            tabstr += '</td></tr>';

                            var Sf_ViolentCrimesClearanceRate = $("Sf_ViolentCrimesClearanceRate", data).text().trim();
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">暴力犯罪破獲率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Sf_ViolentCrimesClearanceRateYear", data).text().trim() + '年' + '</td>';
                            if (Sf_ViolentCrimesClearanceRate != "─") {
                                tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Sf_ViolentCrimesClearanceRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            }
                            else {
                                 tabstr += '<td align="right" nowrap="nowrap">' + $("Sf_ViolentCrimesClearanceRate", data).text().trim(); + '</td>';
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
        
        //撈能源列表
        function getEnergyList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEnergyList.aspx",
                data: {
                    CityNo: $.getQueryString("city"),
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">再生能源裝置容量數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ene_DeviceCapacityNumYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("Ene_DeviceCapacityNum", data).text().trim()).toFixed(0)) + '千瓦' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">台電購入再生能源電量</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ene_TPCBuyElectricityYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Ene_TPCBuyElectricity", data).text().trim()).toFixed(0)) + '度' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">用電量</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ene_ElectricityUsedYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Ene_ElectricityUsed", data).text().trim()).toFixed(0)) + '度' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">再生能源電量佔用電量比例</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Ene_ReEnergyOfElectricityRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Ene_ReEnergyOfElectricityRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
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
        
        
        //撈健康列表
        function getHealthList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
                data: {
                    CityNo: $.getQueryString("city"),
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">每萬人口病床數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Hea_10KPeopleBedYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("Hea_10KPeopleBed", data).text().trim()).toFixed(2)) + '床' + '</td>';
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
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Hea_LongTermPerson", data).text().trim()).toFixed(0)) + '人' + '</td>';
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
                    CityNo: $.getQueryString("city"),
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
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">15歲以上民間人口之教育程度結構-國中及以下</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_15upJSDownRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right">' + $.FormatThousandGroup(Number($("Edu_15upJSDownRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">15歲以上民間人口之教育程度結構-高中(職)</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_15upHSRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_15upHSRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">15歲以上民間人口之教育程度結構-大專及以上</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_15upUSUpRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_15upUSUpRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國小學生輟學率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_ESStudentDropOutRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_ESStudentDropOutRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國中學生輟學率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_JSStudentDropOutRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_JSStudentDropOutRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國小總學生數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_ESStudentsYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_ESStudents", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國中總學生數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_JSStudentsYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_JSStudents", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">高中(職)總學生數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_HSStudentsYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_HSStudents", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國小-高中(職)原住民學生數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_ESToHSIndigenousYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_ESToHSIdigenous", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國小-高中(職)原住民學生數比例</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_ESToHSIndigenousRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_ESToHSIndigenousRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國中小新住民人數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_ESJSNewInhabitantsYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_ESJSNewInhabitants", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國中小新住民學生比例</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_ESJSNewInhabitantsRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_ESToJSNewInhabitantsRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國中小教師數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_ESJSTeachersYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_ESJSTeachers", data).text().trim()).toFixed(0)) + '人' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國中小生師比(平均每位教師教導學生數)</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_ESJSTeachersOfStudentRateYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_ESJSTeachersOfStudentRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">教育預算</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_BudgetYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_Budget", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">教育預算成長率</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_BudgetUpRateYearDesc", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_BudgetUpRate", data).text().trim()).toFixed(2)) + '%' + '</td>';
                            tabstr += '</td></tr>';
                           
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國小-高中(職)平均每人教育預算</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_ESToHSAvgBudgetYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_ESToHSAvgBudget", data).text().trim()).toFixed(0)) + '千元' + '</td>';
                            tabstr += '</td></tr>';
                            
                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國中小教學電腦數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_ESJSPCNumYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_ESJSPCNum", data).text().trim()).toFixed(0)) + '台' + '</td>';
                            tabstr += '</td></tr>';

                            tabstr += '<tr>';
                            tabstr += '<td align="left" nowrap="nowrap">國中小平均每人教學電腦數</td>';
                            tabstr += '<td align="center" nowrap="nowrap">' + $("Edu_ESJSAvgPCNumYear", data).text().trim() + '年' + '</td>';
                            tabstr += '<td align="right" nowrap="nowrap">' + $.FormatThousandGroup(Number($("Edu_ESJSAvgPCNum", data).text().trim()).toFixed(2)) + '台' + '</td>';
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
        

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="WrapperBody" id="WrapperBody">
        <div class="container margin15T" id="ContentWrapper">

            <div class="twocol titleLineA">
                <div class="left"><span class="font-size4"><%= CityName %></span></div>
                <!-- left -->
                <div class="right">首頁 / <span><%= CityName %></span> / <span><%= CityTableClass %></span></div>
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
