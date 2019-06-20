﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="TableList_Taipei.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.TableList_Taipei" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            getPopulationList();

            //動態產生人口table
            $(document).on("click", "#Population", function () {
                $("#Wrapper").empty();
                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Population_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getPopulationList();
                    x++;
                }
            })

            //動態產生土地table
            $(document).on("click", "#Land", function () {
                $("#Wrapper").empty();
                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Land_list"><thead><tr><th>項目</th><th>資料年度</th><th>土地面積</th></tr></thead><tbody></tbody></table>');
                    getLandList();
                    x++;
                }
            })

            //動態產生觀光table
            $(document).on("click", "#Travel", function () {
                $("#Wrapper").empty();
                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Travel_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getTravelList();
                    x++;
                }
            })

            //動態產生交通table
            $(document).on("click", "#Traffic", function () {
                $("#Wrapper").empty();
                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Traffic_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getTrafficList();
                    x++;
                }
            })

            //動態產生農業table
            $(document).on("click", "#Farming", function () {
                $("#Wrapper").empty();
                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Farming_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getFarmingList();
                    x++;
                }
            })

            //動態產生產業table
            $(document).on("click", "#Industry", function () {
                $("#Wrapper").empty();
                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Industry_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getIndustryList();
                    x++;
                }
            })

            //動態產生零售table
            $(document).on("click", "#Retail", function () {
                $("#Wrapper").empty();
                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Retail_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getRetailList();
                    x++;
                }
            })

            //動態產生智慧安全、治理table
            $(document).on("click", "#Safety", function () {
                $("#Wrapper").empty();
                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Safety_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getSafetyList();
                    x++;
                }
            })

            //動態產生能源table
            $(document).on("click", "#Energy", function () {
                $("#Wrapper").empty();
                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Energy_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getEnergyList();
                    x++;
                }
            })

            //動態產生健康table
            $(document).on("click", "#Health", function () {
                $("#Wrapper").empty();
                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Health_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getHealthList();
                    x++;
                }
            })

            //動態產生教育table
            $(document).on("click", "#Education", function () {
                $("#Wrapper").empty();
                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Education_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getEducationList();
                    x++;
                }
            })
        })// js end

        var CityNo = "02";

        //撈台北市人口列表
        function getPopulationList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "wHandler/GetPopulationList.aspx",
                data: {
                    CityNo: CityNo
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Population_list tbody").empty();
                        var tabstr = '';
                        var tabstr1 = '';
                        var tabstr2 = '';
                        var tabstr3 = '';
                        var tabstr4 = '';
                        var tabstr5 = '';
                        var tabstr6 = '';

                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">年底戶籍總人口數</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_TotalYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_PeopleTotal").text().trim() + '人' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="center" nowrap="nowrap">0-14歲幼年人口數</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("P_Year").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("P_Child").text().trim() + '人' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="center" nowrap="nowrap">0-14歲幼年人口比例</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("P_Year").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("P_ChildPercent").text().trim() + '人' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="center" nowrap="nowrap">15-64歲青壯年人口數</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("P_Year").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("P_Teenager").text().trim() + '人' + '</td>';
                                tabstr3 += '</td></tr>';

                                tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr4 += '<td align="center" nowrap="nowrap">15-64歲青壯年人口比例</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("P_Year").text().trim() + '年' + '</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("P_TeenagerPercent").text().trim() + '人' + '</td>';
                                tabstr4 += '</td></tr>';

                                tabstr5 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr5 += '<td align="center" nowrap="nowrap">65歲以上老年人口數</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("P_Year").text().trim() + '年' + '</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("P_OldMen").text().trim() + '人' + '</td>';
                                tabstr5 += '</td></tr>';

                                tabstr6 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr6 += '<td align="center" nowrap="nowrap">65歲以上歲老年人口比例</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("P_Year").text().trim() + '年' + '</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("P_OldMenPercent").text().trim() + '人' + '</td>';
                                tabstr6 += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Population_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3 + tabstr4 + tabstr5 + tabstr6);
                        //$("#Population_list tbody").append(tabstr1);
                    }
                }
            });
        }

        //撈台北市土地列表
        function getLandList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "wHandler/GetPopulationList.aspx",
                data: {
                    CityNo: CityNo
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Land_list tbody").empty();
                        var tabstr = '';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">土地面積</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_AreaYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("P_Area").text().trim() + 'km2' + '</td>';
                                tabstr += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Land_list tbody").append(tabstr);
                    }
                }
            });
        }

        //撈台北市觀光列表
        function getTravelList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "wHandler/GetTravelList.aspx",
                data: {
                    CityNo: CityNo
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Travel_list tbody").empty();
                        var tabstr = '';
                        var tabstr1 = '';
                        var tabstr2 = '';
                        var tabstr3 = '';
                        var tabstr4 = '';

                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">觀光旅館住用率</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("T_HotelUseYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("T_HotelUseRate").text().trim() + '%' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="center" nowrap="nowrap">觀光遊憩據點(縣市)人次統計</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("T_PointYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("T_PointPeople").text().trim() + '人次' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="center" nowrap="nowrap">觀光旅館家數</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("T_HotelsYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("T_Hotels").text().trim() + '家' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="center" nowrap="nowrap">觀光旅館房間數</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("T_HotelRoomsYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("T_HotelRooms").text().trim() + '間' + '</td>';
                                tabstr3 += '</td></tr>';

                                tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr4 += '<td align="center" nowrap="nowrap">觀光旅館平均房價</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("T_HotelAvgPriceYear").text().trim() + '年' + '</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("T_HotelAvgPrice").text().trim() + '元' + '</td>';
                                tabstr4 += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Travel_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3 + tabstr4);
                    }
                }
            });
        }

        //撈台北市交通列表
        function getTrafficList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "wHandler/GetTrafficList.aspx",
                data: {
                    CityNo: CityNo
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Traffic_list tbody").empty();
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
                                tabstr += '<td align="center" nowrap="nowrap">通勤學民眾運具次數之公共運具市佔率</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_PublicTransportRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_PublicTransportRate").text().trim() + '%' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="center" nowrap="nowrap">自小客車在居家附近每次尋找停車位時間</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarParkTimeYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarParkTime").text().trim() + '分鐘' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="center" nowrap="nowrap">小汽車路邊及路外停車位</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarParkSpaceYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarParkSpace").text().trim() + '個' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="center" nowrap="nowrap">每萬輛小型車擁有路外及路邊停車位數</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_10KHaveCarParkYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_10KHaveCarPark").text().trim() + '位／萬輛' + '</td>';
                                tabstr3 += '</td></tr>';

                                tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr4 += '<td align="center" nowrap="nowrap">汽車登記數</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarCountYear").text().trim() + '年' + '</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_CarCount").text().trim() + '輛' + '</td>';
                                tabstr4 += '</td></tr>';

                                tabstr5 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr5 += '<td align="center" nowrap="nowrap">每百人擁有汽車數</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100HaveCarYear").text().trim() + '年' + '</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100HaveCar").text().trim() + '輛' + '</td>';
                                tabstr5 += '</td></tr>';

                                tabstr6 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr6 += '<td align="center" nowrap="nowrap">每百人擁有汽車數成長率</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100HaveCarRateYearDec").text().trim() + '年' + '</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100HaveCarRate").text().trim() + '%' + '</td>';
                                tabstr6 += '</td></tr>';

                                tabstr7 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr7 += '<td align="center" nowrap="nowrap">每萬輛機動車肇事數</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_10KMotoIncidentsNumYear").text().trim() + '年' + '</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_10KMotoIncidentsNum").text().trim() + '次' + '</td>';
                                tabstr7 += '</td></tr>';

                                tabstr8 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr8 += '<td align="center" nowrap="nowrap">每十萬人道路交通事故死傷人數</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100KNumberOfCasualtiesYear").text().trim() + '年' + '</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Tra_100KNumberOfCasualties").text().trim() + '人' + '</td>';
                                tabstr8 += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Traffic_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3 + tabstr4 + tabstr5 + tabstr6 + tabstr7 + tabstr8);
                    }
                }
            });
        }

        //撈台北市交通列表
        function getFarmingList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "wHandler/GetFarmingList.aspx",
                data: {
                    CityNo: CityNo
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Farming_list tbody").empty();
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
                                tabstr += '<td align="center" nowrap="nowrap">臺閩地區農業天然災害產物損失</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmingLossYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmingLoss").text().trim() + '千元' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="center" nowrap="nowrap">天然災害畜牧業產物損失</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_AnimalLossYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_AnimalLoss").text().trim() + '千元' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="center" nowrap="nowrap">天然災害漁業產物損失</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FishLossYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FishLoss").text().trim() + '千元' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="center" nowrap="nowrap">臺閩地區林業天然災害產物損失</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_ForestLossYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_ForestLoss").text().trim() + '千元' + '</td>';
                                tabstr3 += '</td></tr>';

                                tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr4 += '<td align="center" nowrap="nowrap">農林漁牧天然災害產物損失</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_AllLossYear").text().trim() + '年' + '</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_AllLoss").text().trim() + '千元' + '</td>';
                                tabstr4 += '</td></tr>';

                                tabstr5 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr5 += '<td align="center" nowrap="nowrap">農林漁牧天然災害設施(備)損失</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FacilityLossYear").text().trim() + '年' + '</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FacilityLoss").text().trim() + '千元' + '</td>';
                                tabstr5 += '</td></tr>';

                                tabstr6 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr6 += '<td align="center" nowrap="nowrap">農業產值</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmingOutputValueYear").text().trim() + '年' + '</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmingOutputValue").text().trim() + '千元' + '</td>';
                                tabstr6 += '</td></tr>';

                                tabstr7 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr7 += '<td align="center" nowrap="nowrap">農業產值成長率</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmingOutputRateYearDesc").text().trim() + '年' + '</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmingOutputRate").text().trim() + '%' + '</td>';
                                tabstr7 += '</td></tr>';

                                tabstr8 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr8 += '<td align="center" nowrap="nowrap">農戶人口數</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmerYear").text().trim() + '年' + '</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_Farmer").text().trim() + '人' + '</td>';
                                tabstr8 += '</td></tr>';

                                tabstr9 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr9 += '<td align="center" nowrap="nowrap">平均農業從業人口產值</td>';
                                tabstr9 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmEmploymentOutputValueYear").text().trim() + '年' + '</td>';
                                tabstr9 += '<td align="center" nowrap="nowrap">' + $(this).children("Fa_FarmEmploymentOutputValue").text().trim() + '千元' + '</td>';
                                tabstr9 += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Farming_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3 + tabstr4 + tabstr5 + tabstr6 + tabstr7 + tabstr8 + tabstr9);
                    }
                }
            });
        }

        //撈產業列表
        function getIndustryList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "wHandler/GetIndustryList.aspx",
                data: {
                    CityNo: CityNo
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Industry_list tbody").empty();
                        var tabstr = '';
                        var tabstr1 = '';
                        var tabstr2 = '';
                        var tabstr3 = '';

                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">形成群聚之產業(依工研院產科國際所群聚資料)</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_BusinessYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_Business").text().trim() + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="center" nowrap="nowrap">營運中工廠家數</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_FactoryYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_Factory").text().trim() + '家' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="center" nowrap="nowrap">工廠營業收入</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_IncomeYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_Income").text().trim() + '千元' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="center" nowrap="nowrap">營利事業銷售額</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_SalesYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Ind_Sales").text().trim() + '千元' + '</td>';
                                tabstr3 += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Industry_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3);
                    }
                }
            });
        }

        //撈零售列表
        function getRetailList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "wHandler/GetRetailList.aspx",
                data: {
                    CityNo: CityNo
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Retail_list tbody").empty();
                        var tabstr = '';
                        var tabstr1 = '';
                        var tabstr2 = '';
                        var tabstr3 = '';
                        var tabstr4 = '';
                        var tabstr5 = '';
                        var tabstr6 = '';

                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">攤販經營家數</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Re_StreetStandYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Re_StreetStand").text().trim() + '家' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="center" nowrap="nowrap">攤販從業人數</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_Re_StreetVendorYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_StreetVendor").text().trim() + '人' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="center" nowrap="nowrap">攤販全年收入</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_StreetVendorIncomeYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_StreetVendorIncome").text().trim() + '千元' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="center" nowrap="nowrap">攤販全年平均收入</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_StreetVendorAvgIncomeYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_StreetVendorAvgIncome").text().trim() + '千元' + '</td>';
                                tabstr3 += '</td></tr>';

                                tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr4 += '<td align="center" nowrap="nowrap">零售業營利事業銷售額</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_RetailBusinessSalesYear").text().trim() + '年' + '</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_RetailBusinessSales").text().trim() + '千元' + '</td>';
                                tabstr4 += '</td></tr>';

                                tabstr5 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr5 += '<td align="center" nowrap="nowrap">零售業營利事業銷售額成長率</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_RetailBusinessSalesRateYearDesc").text().trim() + '</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_RetailBusinessSalesRate").text().trim() + '%' + '</td>';
                                tabstr5 += '</td></tr>';

                                tabstr6 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr6 += '<td align="center" nowrap="nowrap">零售業營利事業平均每家銷售額</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_RetailBusinessAvgSalesYear").text().trim() + '年' + '</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Re_RetailBusinessAvgSales").text().trim() + '千元' + '</td>';
                                tabstr6 += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Retail_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3 + tabstr4 + tabstr5 + tabstr6);
                    }
                }
            });
        }

        //撈智慧安全、治理列表
        function getSafetyList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "wHandler/GetSafetyList.aspx",
                data: {
                    CityNo: CityNo
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Safety_list tbody").empty();
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
                                tabstr += '<td align="center" nowrap="nowrap">土壤污染控制場址面積</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_SoilAreaYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_SoilArea").text().trim() + '平方公尺' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="center" nowrap="nowrap">地下水受污染使用限制面積</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_UnderWaterAreaYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_UnderWaterArea").text().trim() + '平方公尺' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="center" nowrap="nowrap">總懸浮微粒排放量</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_PM25QuantityYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_PM25Quantity").text().trim() + '公噸' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="center" nowrap="nowrap">每萬人火災發生次數</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_10KPeopleFireTimesYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_10KPeopleFireTimes").text().trim() + '次' + '</td>';
                                tabstr3 += '</td></tr>';

                                tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr4 += '<td align="center" nowrap="nowrap">每十萬人竊盜案發生數</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleBurglaryTimesYear").text().trim() + '年' + '</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleBurglaryTimes").text().trim() + '件' + '</td>';
                                tabstr4 += '</td></tr>';

                                tabstr5 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr5 += '<td align="center" nowrap="nowrap">竊盜案破獲率</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_BurglaryClearanceRateYear").text().trim() + '</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_BurglaryClearanceRate").text().trim() + '%' + '</td>';
                                tabstr5 += '</td></tr>';

                                tabstr6 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr6 += '<td align="center" nowrap="nowrap">每十萬人刑案發生數</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleCriminalCaseTimesYear").text().trim() + '年' + '</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleCriminalCaseTimes").text().trim() + '件' + '</td>';
                                tabstr6 += '</td></tr>';

                                tabstr7 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr7 += '<td align="center" nowrap="nowrap">刑案破獲率</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CriminalCaseClearanceRateYear").text().trim() + '年' + '</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_CriminalCaseClearanceRate").text().trim() + '%' + '</td>';
                                tabstr7 += '</td></tr>';

                                tabstr8 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr8 += '<td align="center" nowrap="nowrap">每十萬人暴力犯罪發生數</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleViolentCrimesTimesYear").text().trim() + '年' + '</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_100KPeopleViolentCrimesTimes").text().trim() + '件' + '</td>';
                                tabstr8 += '</td></tr>';

                                tabstr9 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr9 += '<td align="center" nowrap="nowrap">暴力犯罪破獲率</td>';
                                tabstr9 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_ViolentCrimesClearanceRateYear").text().trim() + '年' + '</td>';
                                tabstr9 += '<td align="center" nowrap="nowrap">' + $(this).children("Sf_ViolentCrimesClearanceRate").text().trim() + '%' + '</td>';
                                tabstr9 += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Safety_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3 + tabstr4 + tabstr5 + tabstr6 + tabstr7 + tabstr8 + tabstr9);
                    }
                }
            });
        }

        //撈能源列表
        function getEnergyList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "wHandler/GetEnergyList.aspx",
                data: {
                    CityNo: CityNo
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Energy_list tbody").empty();
                        var tabstr = '';
                        var tabstr1 = '';
                        var tabstr2 = '';
                        var tabstr3 = '';

                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">再生能源裝置容量數</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_DeviceCapacityNumYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_DeviceCapacityNum").text().trim() + '千瓦' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="center" nowrap="nowrap">台電購入再生能源電量</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_TPCBuyElectricityYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_TPCBuyElectricity").text().trim() + '度' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="center" nowrap="nowrap">用電量</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_ElectricityUsedYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_ElectricityUsed").text().trim() + '度' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="center" nowrap="nowrap">再生能源電量佔用電量比例</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_ReEnergyOfElectricityRateYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Ene_ReEnergyOfElectricityRate").text().trim() + '%' + '</td>';
                                tabstr3 += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Energy_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3);
                    }
                }
            });
        }

        //撈健康列表
        function getHealthList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "wHandler/GetHealthList.aspx",
                data: {
                    CityNo: CityNo
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Health_list tbody").empty();
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
                                tabstr += '<td align="center" nowrap="nowrap">每萬人口病床數</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_10KPeopleBedYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_10KPeopleBed").text().trim() + '床' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="center" nowrap="nowrap">每萬人口急性一般病床數</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_10KPeopleAcuteGeneralBedYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_10KPeopleAcuteGeneralBed").text().trim() + '床' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="center" nowrap="nowrap">每萬人執業醫事人員數</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_10KpeoplePractitionerYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_10KpeoplePractitioner").text().trim() + '人' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="center" nowrap="nowrap">身心障礙人口占全縣(市)總人口比率</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_DisabledPersonOfCityRateYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_DisabledPersonOfCityRate").text().trim() + '%' + '</td>';
                                tabstr3 += '</td></tr>';

                                tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr4 += '<td align="center" nowrap="nowrap">長期照顧機構可供進駐人數</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_LongTermPersonYear").text().trim() + '年' + '</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_LongTermPerson").text().trim() + '人' + '</td>';
                                tabstr4 += '</td></tr>';

                                tabstr5 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr5 += '<td align="center" nowrap="nowrap">長期照顧機構可供進駐人數佔預估失能老人需求比例</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_LongTermPersonOfOldMenRateYear").text().trim() + '年' + '</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_LongTermPersonOfOldMenRate").text().trim() + '%' + '</td>';
                                tabstr5 += '</td></tr>';

                                tabstr6 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr6 += '<td align="center" nowrap="nowrap">醫療機構數</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_MedicalInstitutionsYear").text().trim() + '年' + '</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_MedicalInstitutions").text().trim() + '所' + '</td>';
                                tabstr6 += '</td></tr>';

                                tabstr7 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr7 += '<td align="center" nowrap="nowrap">平均每一醫療機構服務人數</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_MedicalInstitutionsAvgPersonYear").text().trim() + '年' + '</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_MedicalInstitutionsAvgPerson").text().trim() + '人/所' + '</td>';
                                tabstr7 += '</td></tr>';

                                tabstr8 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr8 += '<td align="center" nowrap="nowrap">政府部門醫療保健支出</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_GOVPayOfNHIYear").text().trim() + '年' + '</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Hea_GOVPayOfNHI").text().trim() + '千元' + '</td>';
                                tabstr8 += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Health_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3 + tabstr4 + tabstr5 + tabstr6 + tabstr7 + tabstr8);
                    }
                }
            });
        }

        //撈教育列表
        function getEducationList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "wHandler/GetEducationList.aspx",
                data: {
                    CityNo: CityNo
                },
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        $("#Education_list tbody").empty();
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
                                tabstr += '<td align="center" nowrap="nowrap">15歲以上民間人口之教育程度結構-國中及以下</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upJSDownRateYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upJSDownRate").text().trim() + '%' + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="center" nowrap="nowrap">15歲以上民間人口之教育程度結構-高中(職)</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upHSRateYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upHSRate").text().trim() + '%' + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="center" nowrap="nowrap">15歲以上民間人口之教育程度結構-大專及以上</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upUSUpRateYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_15upUSUpRate").text().trim() + '%' + '</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="center" nowrap="nowrap">國小學生輟學率</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESStudentDropOutRateYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESStudentDropOutRate").text().trim() + '%' + '</td>';
                                tabstr3 += '</td></tr>';

                                tabstr4 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr4 += '<td align="center" nowrap="nowrap">國中學生輟學率</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_JSStudentDropOutRateYear").text().trim() + '年' + '</td>';
                                tabstr4 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_JSStudentDropOutRate").text().trim() + '%' + '</td>';
                                tabstr4 += '</td></tr>';

                                tabstr5 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr5 += '<td align="center" nowrap="nowrap">國小總學生數</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESStudentsYear").text().trim() + '年' + '</td>';
                                tabstr5 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESStudents").text().trim() + '人' + '</td>';
                                tabstr5 += '</td></tr>';

                                tabstr6 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr6 += '<td align="center" nowrap="nowrap">國中總學生數</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_JSStudentsYear").text().trim() + '年' + '</td>';
                                tabstr6 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_JSStudents").text().trim() + '人' + '</td>';
                                tabstr6 += '</td></tr>';

                                tabstr7 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr7 += '<td align="center" nowrap="nowrap">高中(職)總學生數</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_HSStudentsYear").text().trim() + '年' + '</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_HSStudents").text().trim() + '人' + '</td>';
                                tabstr7 += '</td></tr>';

                                tabstr8 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr8 += '<td align="center" nowrap="nowrap">國小-高中(職)原住民學生數</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSIndigenousYear").text().trim() + '年' + '</td>';
                                tabstr8 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSIdigenous").text().trim() + '人' + '</td>';
                                tabstr8 += '</td></tr>';

                                tabstr9 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr9 += '<td align="center" nowrap="nowrap">國小-高中(職)原住民學生數比例</td>';
                                tabstr9 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSIndigenousRateYear").text().trim() + '年' + '</td>';
                                tabstr9 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSIndigenousRate").text().trim() + '%' + '</td>';
                                tabstr9 += '</td></tr>';

                                tabstr10 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr10 += '<td align="center" nowrap="nowrap">國中小新住民人數</td>';
                                tabstr10 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSNewInhabitantsYear").text().trim() + '年' + '</td>';
                                tabstr10 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSNewInhabitants").text().trim() + '人' + '</td>';
                                tabstr10 += '</td></tr>';

                                tabstr11 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr11 += '<td align="center" nowrap="nowrap">國中小新住民學生比例</td>';
                                tabstr11 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSNewInhabitantsRateYear").text().trim() + '年' + '</td>';
                                tabstr11 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToJSNewInhabitantsRate").text().trim() + '%' + '</td>';
                                tabstr11 += '</td></tr>';

                                tabstr12 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr12 += '<td align="center" nowrap="nowrap">國中小教師數</td>';
                                tabstr12 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSTeachersYear").text().trim() + '年' + '</td>';
                                tabstr12 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSTeachers").text().trim() + '人' + '</td>';
                                tabstr12 += '</td></tr>';

                                tabstr13 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr13 += '<td align="center" nowrap="nowrap">國中小生師比(平均每位教師教導學生數)</td>';
                                tabstr13 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSTeachersOfStudentRateYear").text().trim() + '年' + '</td>';
                                tabstr13 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSTeachersOfStudentRate").text().trim() + '%' + '</td>';
                                tabstr13 += '</td></tr>';

                                tabstr14 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr14 += '<td align="center" nowrap="nowrap">教育預算</td>';
                                tabstr14 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_BudgetYear").text().trim() + '年' + '</td>';
                                tabstr14 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_Budget").text().trim() + '千元' + '</td>';
                                tabstr14 += '</td></tr>';

                                tabstr15 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr15 += '<td align="center" nowrap="nowrap">教育預算成長率</td>';
                                tabstr15 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_BudgetUpRateYearDesc").text().trim() + '年' + '</td>';
                                tabstr15 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_BudgetUpRate").text().trim() + '%' + '</td>';
                                tabstr15 += '</td></tr>';

                                tabstr16 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr16 += '<td align="center" nowrap="nowrap">國小-高中(職)平均每人教育預算</td>';
                                tabstr16 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSAvgBudgetYear").text().trim() + '年' + '</td>';
                                tabstr16 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESToHSAvgBudget").text().trim() + '千元' + '</td>';
                                tabstr16 += '</td></tr>';

                                tabstr17 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr17 += '<td align="center" nowrap="nowrap">國中小教學電腦數</td>';
                                tabstr17 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSPCNumYear").text().trim() + '年' + '</td>';
                                tabstr17 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSPCNum").text().trim() + '台' + '</td>';
                                tabstr17 += '</td></tr>';

                                tabstr18 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr18 += '<td align="center" nowrap="nowrap">國中小平均每人教學電腦數</td>';
                                tabstr18 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSAvgPCNumYear").text().trim() + '年' + '</td>';
                                tabstr18 += '<td align="center" nowrap="nowrap">' + $(this).children("Edu_ESJSAvgPCNum").text().trim() + '台' + '</td>';
                                tabstr18 += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Education_list tbody").append(tabstr + tabstr1 + tabstr3 + tabstr4 + tabstr5 + tabstr6 + tabstr7 + tabstr8 + tabstr9 + tabstr10 + tabstr11 + tabstr12 + tabstr13 + tabstr14 + tabstr15 + tabstr16 + tabstr17 + tabstr18);
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
                <div class="left"><span class="font-size4">台北市人口</span></div>
                <!-- left -->
                <div class="right"><%--首頁 / 桃園市 / 桃園市人口--%></div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div class="tabmenublockV2wrapper margin10T">
                <div class="tabmenublockV2">
                    <span class="SlimTabBtnV2 SlimTabBtnV2Current"><a id="Population" href="javascript:void(0)" target="_self">人口</a></span>
                    <span class="SlimTabBtnV2"><a id="Land" href="javascript:void(0)" target="_self">土地</a></span>
                    <span class="SlimTabBtnV2"><a id="Industry" href="javascript:void(0)" target="_self">產業</a></span>
                    <span class="SlimTabBtnV2"><a id="Farming" href="javascript:void(0)" target="_self">農業</a></span>
                    <span class="SlimTabBtnV2"><a id="Travel" href="javascript:void(0)" target="_self">觀光</a></span>
                    <span class="SlimTabBtnV2"><a id="Health" href="javascript:void(0)" target="_self">健康</a></span>
                    <span class="SlimTabBtnV2"><a id="Retail" href="javascript:void(0)" target="_self">零售</a></span>
                    <span class="SlimTabBtnV2"><a id="Education" href="javascript:void(0)" target="_self">教育</a></span>
                    <span class="SlimTabBtnV2"><a id="Traffic" href="javascript:void(0)" target="_self">交通</a></span>
                    <span class="SlimTabBtnV2"><a id="Energy" href="javascript:void(0)" target="_self">能源</a></span>
                    <span class="SlimTabBtnV2"><a id="Safety" href="javascript:void(0)" target="_self">智慧安全、治理</a></span>
                </div>
                <!-- tabmenublock -->
            </div>
            <!-- tabmenublockV2wrapper -->

            <div class="stripeMe margin10T font-normal" id="Wrapper">
                <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Population_list">
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
    <a href="#twmap" class="twbtn open-popup-link">開啟全台地圖</a>
    <div id="twmap" class="magpopup magSizeS mfp-hide">
    <div class="magpopupTitle">台灣地圖</div>
    <div class="padding10ALL">

        <!-- taiwan map start -->
        <div class="obj-wrapperT1">
            <div class="SVGcontent">
                <svg version="1.0" id="taiwanmap" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="100%" height="100%" viewBox="0 0 540 530" style="enable-background:new 0 0 540 530;" xml:space="preserve">
<path style="" d="M435.313,287.525c-0.046,0.353-0.077,0.717-0.11,1.081c-0.551,7.164-2.204,12.124-2.204,12.124
	s-4.409,7.99-5.787,11.022c-1.377,3.03-3.581,6.338-3.03,11.298c0.551,4.959,1.653,5.234,0.826,6.889
	c-0.826,1.653-1.377,3.307,0,4.408c1.378,1.103,3.307,2.204,1.103,3.308c-2.204,1.102-4.133,1.102-4.96,1.653
	c-0.827,0.551-3.031,0.826-4.96,3.856c-1.93,3.032-3.858,12.676-6.889,16.534c-3.031,3.857-4.134,7.164-5.787,8.817
	c-1.652,1.653-3.582,2.204-4.96,4.685c-1.378,2.479-2.479,0.552-2.204,4.684c0.275,4.134,0,9.095,0,9.095s1.378,1.652-10.747,8.542
	c-12.125,6.889-12.951,11.022-14.054,14.88s-7.716,21.217-8.817,25.351c-1.103,4.133-6.063,15.155-6.614,17.359
	c-0.551,2.205-1.377,12.4-0.826,14.88h-1.93c0,0-2.621-0.551-4.826-2.061c-2.204-1.521-2.613-1.102-3.857-1.939
	c-1.235-0.816-0.265-0.959-1.102-2.204c-0.816-1.235-1.367-1.786-2.471-3.164c-1.102-1.378-0.419-2.062,0.133-3.307
	c0.551-1.245,0.826-1.245,0.551-2.756s-3.174-2.479-4.134-2.612c-0.958-0.143-0.958-0.286-1.378-0.551
	c-0.417-0.286-0.968-1.796-0.968-4.828c0-3.03,1.652-1.784,2.49-2.337c0.815-0.551,2.204-0.969,2.755-3.856
	c0.551-2.899-0.551-0.971-1.653-2.899c-1.102-1.93-0.971-0.959-1.246-1.654c-0.275-0.693-1.653-5.785-2.06-6.47
	c-0.42-0.694-1.522-2.348-0.839-4.409c0.694-2.071-0.408-2.622-1.366-4c-0.972-1.378,0.815-2.061,0.815-3.163
	s0.551-2.205,1.39-4.145c0.815-1.918,2.469-3.858,3.437-5.643c0.972-1.786,2.626-1.786,2.339-4.961
	c-0.133-1.587-0.232-1.93-0.232-1.962c0.011-0.011,0.12,0.221,0.375-0.11c0.551-0.684,2.063,0,3.164-0.133
	c1.103-0.132,1.52-0.969,3.449-1.102c1.929-0.132,1.929-1.653,3.164-2.204c1.244-0.552,2.898-0.827,3.449-1.235
	c0.551-0.418,0.959-4.827,0.959-5.798c0-0.958,0-3.57,0-3.57l-2.613-3.307c0,0-1.378-0.694-1.653-1.102
	c-0.275-0.42-2.61-3.176-2.61-3.176s0.417-1.51,0.462-2.766c0.021-0.354,0-0.684-0.056-0.959c-0.275-1.234-0.406-2.613-0.406-2.613
	s-2.35-1.929-2.9-2.898c-0.552-0.959-1.509-3.99-1.929-5.511c-0.417-1.51,1.102-3.989,1.653-5.225
	c0.551-1.246,0.826-1.653,1.377-2.49c0.551-0.816,1.93-1.235,3.583-3.308c1.653-2.062,0.275-1.102,0.275-2.204
	c0-1.102,0.409-2.469,0.409-4.409c0-1.918,0-0.815,0.286-3.02c0.265-2.204,0.958-1.521,1.233-3.043c0.275-1.509,0-1.233,0.134-2.062
	c0.142-0.826,0.417-3.03,0.417-4.408c0-1.377-1.233-2.348-0.551-3.306c0.685-0.96,1.521-0.96,2.756-2.348
	c1.236-1.367,0.971-1.511,0.971-1.919c0-0.418,0.132-2.49,0.683-3.45c0.551-0.958,0.551-1.929,0.826-2.348
	c0.275-0.407,1.653-1.653,2.063-2.061c0.417-0.408,1.939-1.377,2.49-2.205c0.553-0.826,2.612-3.03,4.265-3.857
	c1.654-0.826,1.379-0.959,3.308-1.796c1.93-0.816,2.898-1.235,2.898-1.235l2.204-1.378l0.728-0.418
	c0.223,0.44,0.375,0.661,1.06,1.521c1.103,1.377,0.275,1.511,0.683,2.348c0.42,0.815,0,2.062,0.42,4.266
	c0.418,2.205,0.418,0.826,1.102,1.654c0.684,0.826,3.583,1.377,3.583,1.377s2.06,1.521,3.448,2.756
	c1.367,1.234,0.686,0.419,3.021,0.826c2.349,0.408,0.551-0.275,2.073-0.693c1.52-0.409,0.969,0.286,3.173,1.52
	c2.204,1.235,0,0,1.367,2.757c1.388,2.755,0.971,1.652,1.939,3.03c0.96,1.379,3.572,2.348,5.225,4.134
	c1.653,1.786,0.552,1.102,1.798,2.755c1.245,1.653,1.796,3.308,2.479,3.583s2.756-1.511,4.409-1.93
	c1.653-0.418,1.521-0.275,1.233-2.204c-0.264-1.929-0.264-1.378-0.264-2.888c0-1.521,0.264-1.939,0.959-3.307
	c0.693-1.388,1.245-2.072,2.205-4.96c0.958-2.899,0.692-2.623,1.244-3.307c0.551-0.694,2.338-4.145,3.164-5.511
	c0.827-1.39-0.551-4.695-0.551-5.38c0-0.683,1.653-2.622,2.205-3.438c0.551-0.839,1.653-2.072,1.929-2.624s1.377-1.786,1.784-2.888
	c0.42-1.104-0.683-2.348-1.367-4.276c-0.692-1.93,1.512-4.277,1.512-5.512s1.796-1.377,2.897-1.785
	c1.103-0.42,3.307-0.971,3.307-0.971l3.021,0.551L435.313,287.525z" class="areabox itemhintfollow" title="臺東縣"/>
<path style=";" d="M462.901,154.003c0.981,0,6.811,0,8.136,0c-0.386,1.521-0.773,2.898-1.114,3.99
	c-1.653,5.235-0.826,6.062-3.857,9.368s-6.889,3.583-8.817,8.267c-1.93,4.684,0.552,7.715-1.378,10.195
	c-1.929,2.48-3.857,6.889-3.857,9.369c0,2.48,2.204,4.96,2.755,6.063s1.654,1.929-0.275,3.582c-1.929,1.654-4.408,3.858-4.408,5.511
	s1.653,3.031,1.102,4.133c-0.551,1.102-2.205,8.542-4.96,14.329c-2.755,5.787-0.551,9.093-2.479,13.502
	c-1.93,4.41-1.93,12.675-2.756,13.503c-0.827,0.826-2.479,17.084-2.479,19.289c0,2.094-2.481,5.919-3.197,12.421l-0.254-0.022
	l-3.021-0.551c0,0-2.204,0.551-3.307,0.971c-1.102,0.408-2.897,0.551-2.897,1.785s-2.204,3.582-1.512,5.512
	c0.685,1.929,1.787,3.173,1.367,4.276c-0.407,1.102-1.509,2.336-1.784,2.888s-1.378,1.785-1.929,2.624
	c-0.552,0.815-2.205,2.755-2.205,3.438c0,0.685,1.378,3.99,0.551,5.38c-0.826,1.366-2.613,4.816-3.164,5.511
	c-0.552,0.684-0.286,0.407-1.244,3.307c-0.96,2.888-1.512,3.572-2.205,4.96c-0.695,1.367-0.959,1.786-0.959,3.307
	c0,1.51,0,0.959,0.264,2.888c0.287,1.929,0.42,1.786-1.233,2.204c-1.653,0.419-3.726,2.205-4.409,1.93s-1.234-1.93-2.479-3.583
	c-1.246-1.653-0.145-0.969-1.798-2.755c-1.652-1.786-4.265-2.755-5.225-4.134c-0.969-1.378-0.552-0.275-1.939-3.03
	c-1.367-2.757,0.837-1.521-1.367-2.757c-2.204-1.233-1.653-1.929-3.173-1.52c-1.522,0.418,0.275,1.102-2.073,0.693
	c-2.335-0.407-1.653,0.408-3.021-0.826c-1.389-1.234-3.448-2.756-3.448-2.756s-2.899-0.551-3.583-1.377
	c-0.684-0.828-0.684,0.551-1.102-1.654c-0.42-2.204,0-3.45-0.42-4.266c-0.407-0.837,0.42-0.971-0.683-2.348
	c-0.685-0.859-0.837-1.08-1.06-1.521c-0.131-0.265-0.286-0.618-0.594-1.234c-0.826-1.653,0.417-0.552-0.826-1.653
	c-1.247-1.103,1.378-0.275-1.93-1.654c-3.307-1.378-4.685-1.796-4.685-1.796s-0.275-1.234-0.275-1.654
	c0-0.407,1.929-3.02,1.929-3.02s1.795,0.408,1.929-1.246c0.133-1.652,0.684-1.928,0.552-2.348c-0.133-0.407-1.103-4.122-1.103-4.122
	c2.071,0.816,0.684,0,2.622-1.245c1.918-1.246,2.756-3.031,2.756-3.582s-0.142-2.888,0.551-3.858
	c0.685-0.969,0.265-1.652,0.96-2.072c0.694-0.407,1.653,0.144,3.449,0.144c1.787,0,1.918-0.551,5.37-1.652
	c3.447-1.104,0.957-1.654,1.102-2.48c0.142-0.827,0.692-3.307,1.378-4.685c0.682-1.377,2.071-0.551,2.622-0.551
	s2.204-2.205,4.122-3.715c1.939-1.52,1.521-1.102,2.755-2.755c1.247-1.653,0,0,0.695-2.204c0.694-2.205,1.245-2.072,1.245-2.755
	c0-0.695-1.102-2.491-0.551-4.001c0.551-1.511,1.367-1.797,2.063-3.715c0.692-1.94-0.275-1.245-0.961-2.755
	c-0.693-1.521-1.388-1.521-2.756-4.145c-1.389-2.612,0,0-1.52-2.469c-1.521-2.491,0.827-1.246,1.929-2.623
	c1.103-1.378,2.479-3.726,2.755-5.236c0.277-1.51-0.275-3.857,0.694-5.235c0.96-1.378,0.685-2.072,0.685-3.031
	c0-0.959,0.551-4.552,0.551-4.552s1.378-2.888,1.929-4.266c0.551-1.378-0.409-3.307-0.275-4.817c0.131-1.521-0.42-1.654-0.42-3.307
	c0-1.654,0-1.103,0-2.205s0.286-1.521,0.42-2.756c0.131-1.245,1.103-1.389,2.336-2.348c1.247-0.959,1.798-1.796,2.9-3.307
	c1.102-1.51,0.551-1.653,1.794-3.582c1.236-1.929,0.816-0.827,1.104-1.377c0.264-0.551-1.245-1.929-2.205-2.899
	c-0.969-0.959-0.837-0.684-2.204-1.654c-1.389-0.959-1.521-1.653-2.622-3.307c-1.103-1.653-0.972-1.234-1.378-2.204
	c-0.409-0.959,0.551-0.551,1.245-1.367c0.684-0.838,1.785-1.797,3.57-2.491c1.798-0.684,1.247-0.816,2.204-1.235
	c0.972-0.418,0.696,0.419,1.798,1.654c1.104,1.234,0.551,0.551,1.104,0.418c0.551-0.143,0.551-0.97,0.275-2.204
	c-0.275-1.246-0.553-2.205-0.134-3.307c0.409-1.103,1.366-1.796,3.164-3.45c1.796-1.654,0.551-1.103,1.509-3.031
	c0.971-1.929,0-0.827,0.42-2.072c0.418-1.234,1.103-1.234,1.93-2.205c0.826-0.959,1.929-1.653,2.479-2.336s1.378-2.337,2.204-3.582
	c0.826-1.246,0.275-6.613,0.275-6.613l0.022-0.033c0.297,0.165,0.572,0.396,0.805,0.727c0.969,1.367,0.275,2.062,1.52,2.205
	c1.236,0.132,3.44,0.132,3.991,0.551c0.551,0.408,0.551,0.408,2.888,1.785c2.349,1.378,3.041,0.684,4.553,1.378
	c1.51,0.694,2.205,1.653,3.714,1.377c1.521-0.275,0.971,0.132,2.755-0.827c1.797-0.959,1.654-0.408,2.625-2.205
	c0.968-1.796,2.621-3.714,2.621-3.714s0.816-0.838,3.021,0.551c2.204,1.367,3.45,1.367,4.276,2.336
	C460.555,153.452,461.799,154.003,462.901,154.003z" class="areabox itemhintfollow" title="花蓮縣"/>
<path style="" d="M341.14,399.07c0,0.032,0.1,0.375,0.232,1.962c0.287,3.175-1.367,3.175-2.339,4.961
	c-0.968,1.784-2.621,3.725-3.437,5.643c-0.839,1.939-1.39,3.042-1.39,4.145s-1.787,1.785-0.815,3.163
	c0.958,1.378,2.061,1.929,1.366,4c-0.684,2.062,0.419,3.715,0.839,4.409c0.406,0.685,1.784,5.776,2.06,6.47
	c0.275,0.695,0.145-0.275,1.246,1.654c1.103,1.929,2.204,0,1.653,2.899c-0.551,2.888-1.939,3.306-2.755,3.856
	c-0.838,0.553-2.49-0.693-2.49,2.337c0,3.032,0.551,4.542,0.968,4.828c0.42,0.265,0.42,0.408,1.378,0.551
	c0.96,0.133,3.858,1.102,4.134,2.612s0,1.511-0.551,2.756c-0.552,1.245-1.234,1.929-0.133,3.307
	c1.104,1.378,1.654,1.929,2.471,3.164c0.837,1.245-0.134,1.388,1.102,2.204c1.244,0.838,1.653,0.419,3.857,1.939
	c2.205,1.51,4.826,2.061,4.826,2.061h1.93c0.551,2.481,1.103,7.441,1.653,11.574c0.551,4.134-0.275,6.338-0.275,7.715
	c0,1.378-0.275,4.409,0,5.236c0.275,0.826,1.652,3.858,0,5.511c-1.653,1.653-3.032,2.756-4.409,3.307
	c-1.378,0.551-1.653,0.826-2.48,4.409c-0.826,3.583-0.275,7.439,0.827,7.991c1.102,0.551,1.653,2.204,1.653,2.204
	s-2.204,0.551-4.133-1.378c-1.93-1.929-2.757-3.582-4.134-4.133c-1.378-0.551-3.857-1.102-6.613,0.551
	c-2.756,1.653-2.479,3.857-4.408,2.756c-1.93-1.103-3.583-3.857-3.583-3.857s0.551-2.48,0.275-4.409s-2.479-4.961-1.653-6.889
	c0.827-1.929,2.48-2.204,2.48-4.409s0-9.094-0.276-11.298c-0.275-2.205-3.856-11.573-4.685-13.502
	c-0.826-1.93-2.755-6.613-5.785-13.227c-3.032-6.613-7.992-7.164-12.4-11.85c-4.409-4.685-7.716-6.613-9.093-7.439
	c-1.379-0.827-1.654-4.134-1.654-4.134s-2.479-2.204-3.857-2.204c-0.595,0-1.466,0.21-2.458,0.265
	c-0.353-0.364-0.793-1.058-1.125-2.326c-0.692-2.623-0.826-2.755-0.826-3.307c0-0.551,0.42-0.286,1.235-1.652
	c0.838-1.39,1.389-1.94,1.653-2.348c0.286-0.409,1.94-0.695,1.653-2.481c-0.264-1.784,0.287-2.887-0.133-4.132
	c-0.418-1.246-2.205-2.899-1.654-4.267c0.551-1.389,0.971-6.348,0.828-7.164c-0.144-0.838,2.063-4.277,2.063-5.654
	c0-1.378,0.692-4.685,0.692-6.063s0.826-2.347,0.96-4.684c0.142-2.338-0.685-3.583,0.142-4.542c0.827-0.97,0.145-0.551,1.512-1.245
	c1.389-0.694,4.275-1.103,6.479-1.653c2.205-0.551,2.205,0.275,3.858,0.143c1.653-0.143,3.03-0.143,3.857-1.388
	c0.826-1.235,0.971-1.918,0.971-1.918s1.654-2.348,2.756-2.348c1.103,0,2.06,0.275,4.541,0.275c2.479,0,1.521,0.275,5.093,0.132
	c3.593-0.132,5.797-0.959,5.797-0.959s-0.551-2.348,2.062-0.826c2.613,1.521,7.99,4.276,7.99,4.276s1.929,0.132,2.756-0.837
	c0.826-0.96,1.235-3.308,1.652-2.889c0.42,0.418,3.583,1.653,3.583,1.653l0.606-0.011c-0.045,1.256-0.462,2.766-0.462,2.766
	s2.335,2.756,2.61,3.176c0.275,0.407,1.653,1.102,1.653,1.102l2.613,3.307c0,0,0,2.612,0,3.57c0,0.971-0.408,5.38-0.959,5.798
	c-0.551,0.408-2.205,0.684-3.449,1.235c-1.235,0.551-1.235,2.072-3.164,2.204c-1.93,0.133-2.347,0.97-3.449,1.102
	c-1.102,0.133-2.613-0.551-3.164,0.133C341.26,399.291,341.15,399.06,341.14,399.07z" class="areabox itemhintfollow" title="屏東縣"/>
<path style="" d="M376.002,306.099l-0.728,0.418l-2.204,1.378c0,0-0.969,0.419-2.898,1.235
	c-1.929,0.837-1.653,0.97-3.308,1.796c-1.652,0.827-3.712,3.031-4.265,3.857c-0.551,0.828-2.073,1.797-2.49,2.205
	c-0.409,0.407-1.787,1.653-2.063,2.061c-0.275,0.419-0.275,1.39-0.826,2.348c-0.551,0.96-0.683,3.032-0.683,3.45
	c0,0.408,0.266,0.552-0.971,1.919c-1.234,1.388-2.071,1.388-2.756,2.348c-0.683,0.958,0.551,1.929,0.551,3.306
	c0,1.378-0.275,3.582-0.417,4.408c-0.134,0.828,0.142,0.553-0.134,2.062c-0.275,1.521-0.969,0.839-1.233,3.043
	c-0.286,2.204-0.286,1.102-0.286,3.02c0,1.94-0.409,3.308-0.409,4.409c0,1.103,1.378,0.143-0.275,2.204
	c-1.653,2.072-3.032,2.491-3.583,3.308c-0.551,0.837-0.826,1.244-1.377,2.49c-0.552,1.235-2.07,3.715-1.653,5.225
	c0.42,1.521,1.377,4.552,1.929,5.511c0.551,0.97,2.9,2.898,2.9,2.898s0.131,1.379,0.406,2.613c0.056,0.275,0.077,0.605,0.056,0.959
	l-0.606,0.011c0,0-3.163-1.235-3.583-1.653c-0.417-0.419-0.826,1.929-1.652,2.889c-0.827,0.969-2.756,0.837-2.756,0.837
	s-5.377-2.755-7.99-4.276c-2.612-1.521-2.062,0.826-2.062,0.826s-2.204,0.827-5.797,0.959c-3.571,0.144-2.613-0.132-5.093-0.132
	c-2.481,0-3.438-0.275-4.541-0.275c-1.102,0-2.756,2.348-2.756,2.348s-0.145,0.683-0.971,1.918
	c-0.827,1.245-2.204,1.245-3.857,1.388c-1.653,0.133-1.653-0.693-3.858-0.143c-2.204,0.551-5.091,0.959-6.479,1.653
	c-1.367,0.694-0.685,0.275-1.512,1.245c-0.826,0.959,0,2.204-0.142,4.542c-0.134,2.337-0.96,3.306-0.96,4.684
	s-0.692,4.685-0.692,6.063c0,1.377-2.206,4.816-2.063,5.654c0.143,0.816-0.277,5.775-0.828,7.164
	c-0.551,1.367,1.236,3.021,1.654,4.267c0.42,1.245-0.131,2.348,0.133,4.132c0.287,1.786-1.367,2.072-1.653,2.481
	c-0.265,0.407-0.815,0.958-1.653,2.348c-0.815,1.366-1.235,1.102-1.235,1.652c0,0.552,0.134,0.684,0.826,3.307
	c0.332,1.269,0.772,1.962,1.125,2.326c-1.279,0.065-2.757-0.121-4.155-1.367c-2.48-2.205-8.817-8.542-11.574-12.124
	c-2.755-3.582-6.613-6.889-6.613-8.817s1.654-4.685,1.378-7.165s-3.858-7.99-3.858-7.99c-2.479-3.858-3.858-10.472-5.235-13.503
	c-1.378-3.031-3.858-7.164-4.684-11.849c-0.044-0.231-0.078-0.452-0.11-0.661c0.894,0.044,2.248,0.065,2.866-0.023
	c0.959-0.143,0,0,1.246,0c1.234,0,1.367,0.685,2.756,1.786c1.366,1.103,1.785,0.685,4.54,0.685s1.929,0.693,5.787,0.143
	c3.856-0.552,1.928-0.275,3.45-0.408c1.51-0.144,2.336,0,3.989-0.286c1.653-0.265,1.236-0.133,3.727-1.653
	c2.469-1.51,1.652-0.959,2.611-1.653c0.959-0.683,1.512-1.786,2.755-3.439c1.247-1.652,2.063-3.306,2.899-4.276
	c0.816-0.958,2.206-3.57,4.123-5.367c1.939-1.797,4.276-3.583,6.48-4.96c2.205-1.378,3.726-3.582,5.235-5.512
	c1.512-1.929,0.96-1.797,1.798-4.133c0.815-2.337,1.784-2.072,3.714-4.276c1.928-2.205,1.652-2.337,2.899-3.715
	c1.232-1.377,0.957-1.51,2.335-3.307c1.379-1.797,0.826-1.797,1.104-2.898c0.275-1.103-0.684-1.919-0.419-3.715
	c0.286-1.797,0.142-0.695,0.97-2.348c0.826-1.653,0-1.234,0.275-4.122c0.275-2.899,0.275-1.103,1.246-2.348
	c0.958-1.246,0.552,0,2.47-0.96c1.938-0.969,1.388-0.551,2.755-0.969c1.389-0.419,1.796-0.685,3.593-1.786
	c1.784-1.103,0.683-0.694,1.784-2.072c1.104-1.378,0.686-1.235,2.073-2.204c1.368-0.97,0.959-0.419,3.858-1.235
	c2.888-0.837,1.367-1.245,2.755-3.041c1.368-1.786,1.234-1.511,1.919-3.164c0.693-1.652,2.204-2.756,2.49-3.163
	c0.266-0.419,3.308-2.755,4.675-3.308c1.388-0.551,1.388-1.795,3.723-2.623c2.074-0.728,4.367-2.865,4.861-3.351h0.012
	c0.331-0.033,0.748-0.065,1.323-0.087c3.174-0.144,1.103,0.264,4.551,0.958c3.451,0.694,2.9,0.96,4.002,1.511
	c1.104,0.551,0.265,0.551,2.337,1.388c0,0,0.97,3.715,1.103,4.122c0.132,0.42-0.419,0.695-0.552,2.348
	c-0.134,1.654-1.929,1.246-1.929,1.246s-1.929,2.612-1.929,3.02c0,0.42,0.275,1.654,0.275,1.654s1.378,0.418,4.685,1.796
	c3.308,1.379,0.683,0.552,1.93,1.654c1.243,1.102,0,0,0.826,1.653C375.716,305.48,375.871,305.834,376.002,306.099z" class="areabox itemhintfollow" title="高雄市"/>
<path style="" d="M319.327,320.295c-0.265,1.796,0.694,2.612,0.419,3.715c-0.277,1.102,0.275,1.102-1.104,2.898
	c-1.378,1.797-1.103,1.93-2.335,3.307c-1.247,1.378-0.972,1.51-2.899,3.715c-1.93,2.204-2.898,1.939-3.714,4.276
	c-0.838,2.336-0.286,2.204-1.798,4.133c-1.51,1.93-3.03,4.134-5.235,5.512c-2.204,1.377-4.541,3.163-6.48,4.96
	c-1.917,1.797-3.307,4.409-4.123,5.367c-0.837,0.971-1.652,2.624-2.899,4.276c-1.243,1.653-1.796,2.757-2.755,3.439
	c-0.959,0.694-0.143,0.144-2.611,1.653c-2.49,1.521-2.073,1.389-3.727,1.653c-1.653,0.286-2.479,0.143-3.989,0.286
	c-1.522,0.133,0.406-0.144-3.45,0.408c-3.858,0.551-3.032-0.143-5.787-0.143s-3.174,0.418-4.54-0.685
	c-1.389-1.102-1.522-1.786-2.756-1.786c-1.246,0-0.286-0.143-1.246,0c-0.618,0.089-1.972,0.067-2.866,0.023
	c-0.717-4.057-0.795-4.432-2.37-7.055c-1.653-2.755-1.103-5.786-3.032-7.164s-1.654-0.826-3.031-2.479
	c-1.378-1.654,0.738-2.116,0.187-2.293c-0.551-0.188-5.511-2.205-6.249-4.045c-0.739-1.841-0.915-4.045,0.551-5.876
	c1.467-1.841,4.044-4.96,4.044-5.511s-0.737-0.551-1.102-2.204c-0.375-1.653-1.29-7.539,0.728-10.295
	c2.027-2.756,3.857-4.96,3.857-7.164c0-2.205,1.29-8.994,1.29-8.994l0.022,0.022l2.316,3.229c0,0,0.838,0.969,4,2.348
	c3.165,1.377,0.551,0.143,2.755,0.407c2.204,0.286,2.349-1.653,2.481-2.612c0.133-0.959,1.929-2.204,3.03-2.898
	c1.103-0.684,0.96-0.408,2.613-1.51c1.654-1.103,1.94-1.103,4-3.858c2.063-2.755,2.063-1.378,2.755-1.929
	c0.696-0.551,2.614-1.378,3.583-1.929c0.97-0.551,5.093-0.551,5.093-0.551s4.145-1.246,4.552-1.246c0.409,0,3.715,0.971,5.368,0.552
	c1.654-0.409,2.347,0.419,3.593,0.694c1.233,0.275,1.233,0.275,2.47,0.958c1.244,0.695,3.173,5.247,4.96,6.758
	c1.796,1.509,0.551,1.509,0.837,1.928c0.266,0.42,0.408,1.378-0.551,4.408c-0.971,3.032-0.695,1.654-0.42,2.757
	c0.275,1.102-0.275,1.786-0.275,3.306c0,1.521,0.551,3.858,1.93,5.645c1.377,1.797,2.755,0.418,4.684,0
	c1.929-0.408,4.003-2.205,4.003-2.205L319.327,320.295z" class="areabox itemhintfollow" title="台南市"/>
<path style="" d="M354.466,283.371c3.15,0.572,2.811,0.385,4.309,0.23c-0.494,0.485-2.787,2.623-4.861,3.351
	c-2.335,0.828-2.335,2.072-3.723,2.623c-1.367,0.553-4.409,2.889-4.675,3.308c-0.286,0.407-1.797,1.511-2.49,3.163
	c-0.685,1.653-0.551,1.378-1.919,3.164c-1.388,1.796,0.133,2.204-2.755,3.041c-2.899,0.816-2.49,0.266-3.858,1.235
	c-1.388,0.969-0.97,0.826-2.073,2.204c-1.102,1.378,0,0.97-1.784,2.072c-1.797,1.102-2.204,1.367-3.593,1.786
	c-1.367,0.418-0.816,0-2.755,0.969c-1.918,0.96-1.512-0.286-2.47,0.96c-0.971,1.245-0.971-0.552-1.246,2.348
	c-0.275,2.888,0.551,2.469-0.275,4.122c-0.828,1.652-0.684,0.551-0.97,2.348l-5.224-1.797c0,0-2.074,1.797-4.003,2.205
	c-1.929,0.418-3.307,1.797-4.684,0c-1.379-1.786-1.93-4.123-1.93-5.645c0-1.52,0.551-2.204,0.275-3.306
	c-0.275-1.103-0.551,0.275,0.42-2.757c0.959-3.03,0.816-3.988,0.551-4.408c-0.286-0.419,0.959-0.419-0.837-1.928
	c-1.787-1.511-3.716-6.063-4.96-6.758c-1.236-0.683-1.236-0.683-2.47-0.958c-1.246-0.275-1.938-1.104-3.593-0.694
	c-1.653,0.419-4.959-0.552-5.368-0.552c-0.407,0-4.552,1.246-4.552,1.246s-4.123,0-5.093,0.551
	c-0.969,0.551-2.887,1.378-3.583,1.929c-0.692,0.551-0.692-0.826-2.755,1.929c-2.061,2.756-2.347,2.756-4,3.858
	c-1.653,1.102-1.51,0.826-2.613,1.51c-1.102,0.694-2.897,1.939-3.03,2.898c-0.132,0.959-0.277,2.898-2.481,2.612
	c-2.205-0.265,0.41,0.97-2.755-0.407c-3.162-1.379-4-2.348-4-2.348l-2.316-3.229c0.133,0.1,0.826,0.495,1.818-1.312
	c1.103-2.018,2.205-4.961,2.382-6.978c0.187-2.028-2.568-4.597-2.755-7.902c-0.177-3.308-0.177-6.063-0.177-6.063l0.463-2.701
	l0.452,0.078c0,0,3.176,0.143,4.542,0.143c1.389,0,5.378-0.827,6.205-1.378c0.827-0.551,3.032-0.683,4.684-2.072
	c1.654-1.367,2.756-2.062,4.686-3.438c1.928-1.378,1.797-1.378,2.899-3.031c1.102-1.653,3.162-3.163,3.162-3.163
	s0.961-1.389,2.614-1.653c1.652-0.287,7.856-2.348,7.856-2.348s4.819-0.694,5.37-0.694s0.286-2.338,2.49-0.817
	c2.204,1.511,2.611,0.96,4.123,1.786c1.52,0.826,3.172,1.521,6.204,2.887c3.03,1.389,6.063,3.451,7.572,2.491
	c1.521-0.969,1.521-1.52,2.622-1.652c1.103-0.143,0.827-0.552,2.757,1.102c1.929,1.653,2.338,2.469,4.277,1.918
	c1.918-0.551,3.989-1.102,4.96-1.367c0.958-0.286,2.06-0.286,1.918-1.938c-0.134-1.654,0.837-3.99,0.837-3.99
	c1.653,1.102,4.409,0.275,5.512,0.275c1.102,0,2.469,1.245,3.989,1.797c1.521,0.551,1.102,2.469,1.102,2.469
	s0.552,6.613,0.972,10.063c0.406,3.45,0.551,1.797,1.508,3.715c0.961,1.939,2.901,1.797,3.308,1.797
	C349.087,282.269,350.607,282.676,354.466,283.371z" class="areabox itemhintfollow" title="嘉義縣"/>
<path style="" d="M331.452,266.144c0.142,1.652-0.96,1.652-1.918,1.938c-0.971,0.266-3.042,0.816-4.96,1.367
	c-1.939,0.551-2.349-0.265-4.277-1.918c-1.93-1.653-1.654-1.244-2.757-1.102c-1.102,0.133-1.102,0.684-2.622,1.652
	c-1.51,0.96-4.542-1.102-7.572-2.491c-3.032-1.366-4.685-2.061-6.204-2.887c-1.512-0.826-1.919-0.275-4.123-1.786
	c-2.204-1.521-1.939,0.817-2.49,0.817s-5.37,0.694-5.37,0.694s-6.204,2.061-7.856,2.348c-1.653,0.264-2.614,1.653-2.614,1.653
	s-2.061,1.51-3.162,3.163c-1.103,1.653-0.972,1.653-2.899,3.031c-1.929,1.377-3.032,2.071-4.686,3.438
	c-1.652,1.39-3.857,1.521-4.684,2.072c-0.826,0.551-4.815,1.378-6.205,1.378c-1.366,0-4.542-0.143-4.542-0.143l-0.452-0.078
	l0.452-2.623c0,0-0.364-8.454-0.738-10.471c-0.364-2.029-1.654-4.96-0.177-7.352c1.467-2.392,3.483-4.222,3.858-6.063
	c0.364-1.84,1.466-3.119,2.018-6.062c0.551-2.943,3.857-6.801,4.596-8.267c0.728-1.467,2.382-4.222,3.307-6.426
	c0.154-0.375,0.354-0.738,0.573-1.08l0.342,0.209c2.48-0.694,5.93,1.786,7.439,2.336c1.512,0.552,10.471-2.204,10.471-2.204
	l5.655-2.337c0,0,5.367,1.367,7.021,1.367c1.654,0,3.717,0.694,5.787,1.103c2.072,0.418,6.613,1.388,9.368,1.245
	c2.756-0.143,1.787,1.378,2.625,1.929c0.814,0.551,2.755,2.623,3.713,3.726c0.926,1.069,0.96-0.32,1.587-0.65
	c-0.065,0.187-0.132,0.408-0.208,0.65c-0.419,1.366,1.102,2.205,1.652,4.123c0.552,1.939-1.785,3.592-1.785,3.592l-1.939,3.021
	c0,0,0.286,0.551,2.623,2.623c2.338,2.072-1.785,3.174-1.93,3.725c-0.142,0.552,0.695,2.613,1.379,5.093
	c0.684,2.48,5.093,1.654,5.093,1.654s3.448-0.971,4.145-1.521c0.682-0.551,1.652,0.418,3.306,1.521
	C332.289,262.153,331.318,264.49,331.452,266.144z" class="areabox itemhintfollow" title="雲林縣"/>
<path style="" d="M320.848,231.291c0.684,0.683,1.378,1.928,0.971,3.174c-0.42,1.234-0.838,0.958-1.102,1.51
	c-0.233,0.452-0.453,0.805-0.763,1.697c-0.627,0.33-0.661,1.719-1.587,0.65c-0.958-1.103-2.898-3.175-3.713-3.726
	c-0.838-0.551,0.131-2.072-2.625-1.929c-2.755,0.143-7.296-0.827-9.368-1.245c-2.07-0.408-4.133-1.103-5.787-1.103
	c-1.653,0-7.021-1.367-7.021-1.367l-5.655,2.337c0,0-8.959,2.756-10.471,2.204c-1.51-0.551-4.959-3.03-7.439-2.336l-0.342-0.209
	c1.048-1.676,2.645-2.998,3.098-4.067c0.551-1.29,1.102-2.018,2.391-4.045c1.278-2.017,2.757-7.892,4.035-9.92
	c1.29-2.017,2.942-4.035,3.856-5.511c0.926-1.466,2.205-5.137,2.205-5.137l3.307-4.232c0,0,4.409-3.119,5.147-4.585
	c0.738-1.477,0.551-2.392,0.551-3.13c0-0.728,2.392-5.875,3.67-7.341c0.981-1.124,3.341-2.777,4.409-4.222l0.057,0.044l4.123,3.99
	l1.938,2.48l3.021,4.96c0,0,1.795,2.062,3.041,3.45c1.233,1.367,1.784,2.469,2.612,3.307c0.826,0.816,0.408,1.102,0,2.469
	c-0.344,1.179,0,0.75,1.377,1.952c0.244,0.209,0.52,0.474,0.827,0.804c2.062,2.205,0,2.348,0.551,4.96
	c0.551,2.624,2.479,4.409,3.858,5.655c1.377,1.245,0.695,1.377-0.143,3.307c-0.816,1.928-0.816,1.653-1.367,4
	c-0.552,2.336-0.552,2.756-0.838,3.307c-0.265,0.551-0.685,2.469,0.552,5.368C319.469,231.709,320.166,230.607,320.848,231.291z" class="areabox itemhintfollow" title="彰化縣"/>
<path style="" d="M319.954,237.673c0.31-0.893,0.529-1.246,0.763-1.697c0.264-0.552,0.682-0.276,1.102-1.51
	c0.407-1.246-0.287-2.491-0.971-3.174c-0.682-0.684-1.379,0.418-2.622-2.48c-1.236-2.898-0.816-4.816-0.552-5.368
	c0.286-0.551,0.286-0.97,0.838-3.307c0.551-2.348,0.551-2.072,1.367-4c0.838-1.929,1.52-2.062,0.143-3.307
	c-1.379-1.246-3.308-3.031-3.858-5.655c-0.551-2.612,1.511-2.755-0.551-4.96c-0.308-0.331-0.583-0.595-0.827-0.804l0.42-0.012
	c0,0,2.755,0.132,3.988,0.551c1.236,0.408,3.728,1.786,4.685,2.337c0.961,0.551,0.827,0.418,4.554,0.275
	c3.713-0.143,4.122-0.143,5.367-0.143s1.929,0.143,4.267-1.234c2.347-1.378,1.653,1.377,3.041-2.888
	c1.368-4.276,2.205-5.654,2.205-5.654s0.132-0.551,0.683-0.276c0.551,0.276,2.479,0.419,4.278-0.132
	c1.784-0.551,5.641-2.072,6.326-2.623c0.693-0.551-0.408-0.551,1.939-1.653c2.336-1.102,1.367-1.521,3.988-1.786
	c2.626-0.286,3.308,0,4.409-0.143c1.103-0.143,1.378,0.276,3.308-1.377c1.929-1.653,2.204-2.205,2.887-2.48
	c0.696-0.275,4.695-2.899,5.247-3.031c0.551-0.132,2.889-2.072,3.164-2.755c0.275-0.684,0.551-1.235,1.245-1.786
	c0.685-0.551,2.469,0.132,4.267-0.837c1.796-0.959,3.714-2.205,3.714-2.205c0.087-0.022,0.674-0.065,4.144-0.265
	c4.542-0.286,4.408,0.132,5.645-0.694c1.234-0.827,3.438-1.51,3.438-1.51s3.041-1.797,3.45-0.695c0.408,1.102,1.51,0,2.347,0
	c0.816,0,1.918-1.377,2.89-0.959c0.968,0.408,4.275,2.205,4.275,2.205c-0.419,1.102-0.142,2.061,0.134,3.307
	c0.275,1.234,0.275,2.061-0.275,2.204c-0.553,0.132,0,0.816-1.104-0.418c-1.102-1.234-0.826-2.072-1.798-1.654
	c-0.957,0.419-0.406,0.552-2.204,1.235c-1.785,0.694-2.887,1.653-3.57,2.491c-0.694,0.816-1.654,0.408-1.245,1.367
	c0.406,0.97,0.275,0.551,1.378,2.204c1.102,1.654,1.233,2.348,2.622,3.307c1.367,0.97,1.235,0.695,2.204,1.654
	c0.96,0.97,2.469,2.348,2.205,2.899c-0.287,0.551,0.133-0.551-1.104,1.377c-1.243,1.929-0.692,2.072-1.794,3.582
	c-1.103,1.511-1.653,2.348-2.9,3.307c-1.233,0.959-2.205,1.103-2.336,2.348c-0.134,1.235-0.42,1.654-0.42,2.756s0,0.551,0,2.205
	c0,1.653,0.551,1.786,0.42,3.307c-0.134,1.51,0.826,3.438,0.275,4.817c-0.551,1.377-1.929,4.266-1.929,4.266
	s-0.551,3.593-0.551,4.552c0,0.959,0.275,1.653-0.685,3.031c-0.97,1.378-0.417,3.725-0.694,5.235
	c-0.275,1.51-1.652,3.858-2.755,5.236c-1.102,1.377-3.45,0.132-1.929,2.623c1.52,2.469,0.131-0.143,1.52,2.469
	c1.368,2.623,2.063,2.623,2.756,4.145c0.686,1.51,1.653,0.815,0.961,2.755c-0.695,1.918-1.512,2.204-2.063,3.715
	c-0.551,1.51,0.551,3.306,0.551,4.001c0,0.683-0.551,0.551-1.245,2.755c-0.695,2.204,0.552,0.551-0.695,2.204
	c-1.233,1.654-0.815,1.235-2.755,2.755c-1.918,1.51-3.571,3.715-4.122,3.715s-1.94-0.826-2.622,0.551
	c-0.686,1.378-1.236,3.857-1.378,4.685c-0.145,0.826,2.346,1.377-1.102,2.48c-3.452,1.102-3.583,1.652-5.37,1.652
	c-1.796,0-2.755-0.551-3.449-0.144c-0.695,0.42-0.275,1.104-0.96,2.072c-0.692,0.971-0.551,3.308-0.551,3.858
	s-0.838,2.336-2.756,3.582c-1.938,1.245-0.551,2.062-2.622,1.245c-2.072-0.837-1.233-0.837-2.337-1.388
	c-1.102-0.551-0.551-0.816-4.002-1.511c-3.448-0.694-1.377-1.102-4.551-0.958c-0.575,0.021-0.992,0.054-1.323,0.087h-0.012
	c-1.498,0.154-1.158,0.342-4.309-0.23c-3.858-0.695-5.379-1.103-5.787-1.103c-0.406,0-2.347,0.143-3.308-1.797
	c-0.957-1.918-1.102-0.265-1.508-3.715c-0.42-3.449-0.972-10.063-0.972-10.063s0.42-1.918-1.102-2.469
	c-1.521-0.552-2.888-1.797-3.989-1.797c-1.103,0-3.858,0.826-5.512-0.275c-1.653-1.103-2.624-2.072-3.306-1.521
	c-0.696,0.551-4.145,1.521-4.145,1.521s-4.409,0.826-5.093-1.654c-0.684-2.479-1.521-4.541-1.379-5.093
	c0.145-0.551,4.268-1.653,1.93-3.725c-2.337-2.072-2.623-2.623-2.623-2.623l1.939-3.021c0,0,2.337-1.653,1.785-3.592
	c-0.551-1.918-2.071-2.756-1.652-4.123C319.822,238.081,319.889,237.86,319.954,237.673z" class="areabox itemhintfollow" title="南投縣"/>
<path style="" d="M409.379,139.63c0.551,0.155,1.067,0.484,1.432,1.146c1.246,2.204,0,5.092,2.491,6.063
	c2.469,0.959,2.755,2.204,4.959,2.061c2.205-0.143,4.818-1.929,5.776-1.377c0.739,0.418,1.951,0.275,2.922,0.794l-0.022,0.033
	c0,0,0.551,5.368-0.275,6.613c-0.826,1.245-1.653,2.898-2.204,3.582s-1.653,1.377-2.479,2.336c-0.827,0.97-1.512,0.97-1.93,2.205
	c-0.42,1.245,0.551,0.143-0.42,2.072c-0.958,1.929,0.287,1.377-1.509,3.031c-1.798,1.653-2.755,2.347-3.164,3.45
	c0,0-3.308-1.796-4.275-2.205c-0.972-0.418-2.073,0.959-2.89,0.959c-0.837,0-1.938,1.102-2.347,0
	c-0.409-1.102-3.45,0.695-3.45,0.695s-2.204,0.683-3.438,1.51c-1.236,0.827-1.103,0.408-5.645,0.694
	c-3.47,0.199-4.057,0.242-4.144,0.265c0,0-1.918,1.245-3.714,2.205c-1.798,0.97-3.582,0.286-4.267,0.837
	c-0.694,0.551-0.97,1.103-1.245,1.786c-0.275,0.683-2.613,2.623-3.164,2.755c-0.552,0.132-4.551,2.756-5.247,3.031
	c-0.683,0.275-0.958,0.827-2.887,2.48c-1.93,1.653-2.205,1.234-3.308,1.377c-1.102,0.143-1.783-0.143-4.409,0.143
	c-2.621,0.265-1.652,0.684-3.988,1.786c-2.348,1.102-1.246,1.102-1.939,1.653c-0.686,0.551-4.542,2.072-6.326,2.623
	c-1.799,0.551-3.728,0.408-4.278,0.132c-0.551-0.275-0.683,0.276-0.683,0.276s-0.837,1.378-2.205,5.654
	c-1.388,4.266-0.694,1.51-3.041,2.888c-2.338,1.377-3.021,1.234-4.267,1.234s-1.654,0-5.367,0.143
	c-3.727,0.143-3.593,0.275-4.554-0.275c-0.957-0.551-3.448-1.929-4.685-2.337c-1.233-0.418-3.988-0.551-3.988-0.551l-0.42,0.012
	c-1.377-1.202-1.721-0.773-1.377-1.952c0.408-1.367,0.826-1.653,0-2.469c-0.828-0.838-1.379-1.94-2.612-3.307
	c-1.246-1.388-3.041-3.45-3.041-3.45l-3.021-4.96l-1.938-2.48l-4.123-3.99l-0.057-0.044c0.344-0.463,0.552-0.894,0.552-1.29
	c0-1.653,2.027-4.959,2.027-6.25c0-1.29,0-2.755,0.178-4.409c0.187-1.653,1.477-2.392,2.941-3.307
	c1.467-0.915,3.672-6.8,4.045-7.352c0.364-0.551,5.137-10.096,5.137-10.096s1.587-2.303,3.264-4.751l0.23,0.155l2.89,4.96
	c0,0,2.491,2.888,3.593,3.857c1.103,0.97,2.06,1.378,3.571,2.337c1.521,0.969,3.593,1.389,5.654,2.205
	c2.061,0.837,4.001,2.623,5.919,4.144c1.939,1.51,6.349,1.102,7.716,1.918c1.388,0.838,4.96,0.838,7.306,1.103
	c2.35,0.286,0.553-1.367,1.247-2.337c0.683-0.97,1.366-1.653,1.366-2.479c0-0.827,0.839-1.246,1.521-1.654
	c0.685-0.408,2.479,0.694,3.308,0.408c0.826-0.265,0.551,0.143,3.581,0.286c3.032,0.132,1.378,0.959,4.002,2.469
	c2.612,1.521,1.104,1.653,2.754,2.756c1.654,1.102,2.063-1.235,4.409-3.021c2.339-1.797,3.021-0.143,3.44-0.286
	c0.418-0.132,0.97-1.654,2.756-3.164c1.784-1.511,2.623-1.246,4.827-2.48c2.204-1.234,4.122-3.174,4.409-3.582
	c0.264-0.408,1.51-2.205,3.02-2.755c1.522-0.551,1.103,0.826,3.451,1.103c2.347,0.275,0.275-1.378,1.244-3.45
	c0.419-0.905,0.972-2.392,1.466-3.77l0.738,0.055l5.512-0.143C406.688,139.939,408.111,139.267,409.379,139.63z" class="areabox itemhintfollow" title="台中市"/>
<path style="" d="M358.433,98.629c0.795,0.374,1.49,0.792,1.818,1.222c0.961,1.246,2.901,4.817,3.032,6.757
	c0.134,1.918-1.929,2.612,0.551,3.164c2.479,0.551,3.44-0.551,4.828,0.551c1.367,1.102,4.673,2.348,4.816,3.031
	c0.143,0.684,1.93,2.479,2.481,3.174c0.551,0.684,1.377-0.287,0.968,1.918c-0.417,2.205,0.685,0.837-0.417,2.205
	c-1.103,1.388,0.551,2.756,0.417,3.307c-0.142,0.551,0.265,0.418-0.837,1.94c-1.103,1.51-1.653,0-1.367,2.061
	c0.265,2.062,1.512,3.714,2.204,3.857c0.685,0.143,0.816,0.408,2.063-0.827c1.245-1.234,1.93-1.521,3.583-1.521
	c1.652,0,3.724-0.264,4.54-0.264c0.837,0,3.175,0.551,5.51,0.683c2.35,0.133,2.626-0.132,3.594,0.419
	c0.96,0.551,3.716,1.51,3.991,2.336c0.275,0.827,0.826,1.103,0.969,1.929c0.133,0.827,0.408,2.061,0.408,2.061
	s-0.518,1.609-1.146,3.395c-0.494,1.378-1.047,2.865-1.466,3.77c-0.969,2.071,1.103,3.725-1.244,3.45
	c-2.349-0.276-1.929-1.654-3.451-1.103c-1.51,0.551-2.756,2.348-3.02,2.755c-0.287,0.408-2.205,2.348-4.409,3.582
	c-2.204,1.235-3.043,0.97-4.827,2.48c-1.786,1.51-2.338,3.031-2.756,3.164c-0.42,0.143-1.102-1.511-3.44,0.286
	c-2.347,1.786-2.755,4.123-4.409,3.021c-1.65-1.103-0.142-1.235-2.754-2.756c-2.624-1.51-0.97-2.337-4.002-2.469
	c-3.03-0.143-2.755-0.551-3.581-0.286c-0.828,0.286-2.623-0.816-3.308-0.408c-0.682,0.408-1.521,0.827-1.521,1.654
	c0,0.827-0.684,1.51-1.366,2.479c-0.694,0.97,1.103,2.623-1.247,2.337c-2.346-0.265-5.918-0.265-7.306-1.103
	c-1.367-0.816-5.776-0.408-7.716-1.918c-1.918-1.521-3.858-3.307-5.919-4.144c-2.062-0.816-4.134-1.235-5.654-2.205
	c-1.512-0.959-2.469-1.367-3.571-2.337c-1.102-0.969-3.593-3.857-3.593-3.857l-2.89-4.96l-0.23-0.155
	c1.015-1.455,2.051-2.964,2.799-4.067c2.028-2.943,3.681-2.943,3.858-5.698c0.187-2.756,1.102-5.324,2.943-8.079
	c1.84-2.756,3.492-8.267,4.045-8.454c0.551-0.188,3.306-3.67,4.772-4.596c1.466-0.915,7.528-5.511,8.63-6.239
	c1.103-0.738,5.886-4.596,6.25-5.886c0.099-0.375,0.409-1.235,0.772-2.26c0.749,0.1,3.194,0.464,3.77,0.927
	C355.049,97.316,356.924,97.912,358.433,98.629z" class="areabox itemhintfollow" title="苗栗縣"/>
<path style="" d="M421.327,116.858l-0.167-1.057c1.059-0.166,1.962-0.332,2.471-0.375
	c1.509-0.144,4.408,0.551,5.102-1.246c0.684-1.797-0.286-4.552,0.265-6.338c0.311-1.003,0.916-2.436,1.423-3.593
	c0.353-0.088,3.24-0.86,4.926-1.5c1.787-0.694,4.673-2.623,4.673-2.623s2.626-2.48,4.554-3.583c1.929-1.102,1.378-1.377,1.103-3.164
	c-0.275-1.796,0.958-4.144,1.378-5.511c0.418-1.389,1.377-1.103,2.336-2.072c0.971-0.97,0.286-0.826,2.204-1.521
	c1.94-0.684,4.829-1.102,6.899-1.786c2.063-0.683,1.918-1.521,3.991-3.031c2.071-1.51,1.654-1.51,3.307-2.348
	c1.653-0.816,1.52-0.551,2.479-1.51c0.959-0.959,1.796-2.899,3.032-4.133c1.233-1.234,3.582-1.378,6.193-2.888
	c2.624-1.521,0.695-2.491,1.102-4c0.42-1.511,0.42-4.409,0.552-4.817c0.145-0.419,2.072-0.694,6.899-0.97
	c4.817-0.275,5.644-2.336,7.298-1.928c-2.48,1.653-14.88,13.777-15.431,20.391c-0.551,6.613-1.104,21.493,0.551,26.453
	c1.653,4.96,1.653,6.338,3.307,8.267c1.652,1.929,1.929,2.48,1.377,4.409c-0.551,1.929-1.377,2.755-0.826,3.857
	c0.551,1.102,3.308,0.276,0.551,3.858c-2.755,3.582-6.613,4.96-4.684,6.338c1.929,1.377,5.511,0.827,3.857,2.204
	c-1.653,1.378-4.959,3.031-5.512,3.858c-0.551,0.826-1.377,2.479-1.929,3.306c-0.44,0.65-2.083,8.399-3.57,14.197
	c-1.325,0-7.154,0-8.136,0c-1.103,0-2.347-0.552-3.174-1.521c-0.826-0.969-2.072-0.969-4.276-2.336
	c-2.205-1.389-3.021-0.551-3.021-0.551s-1.653,1.918-2.621,3.714c-0.971,1.797-0.828,1.246-2.625,2.205
	c-1.784,0.959-1.233,0.551-2.755,0.827c-1.509,0.275-2.204-0.684-3.714-1.377c-1.512-0.695-2.204,0-4.553-1.378
	c-2.337-1.377-2.337-1.377-2.888-1.785c-0.551-0.419-2.755-0.419-3.991-0.551c-1.244-0.143-0.551-0.837-1.52-2.205
	c-0.232-0.331-0.508-0.562-0.805-0.727c-0.971-0.519-2.183-0.375-2.922-0.794c-0.958-0.552-3.571,1.234-5.776,1.377
	c-2.204,0.143-2.49-1.102-4.959-2.061c-2.491-0.97-1.245-3.858-2.491-6.063c-0.364-0.662-0.881-0.991-1.432-1.146
	c0.1-0.606,0.286-1.654,0.474-2.304c0.275-0.959,0.958-1.796,2.06-3.164c1.103-1.389,2.491-2.623,3.858-4.277
	c1.389-1.653,1.798-1.653,2.899-2.479c1.103-0.827,0.827-1.796,1.509-2.898c0.695-1.102-0.131-2.47,0.287-3.858
	C420.776,119.625,421.16,117.741,421.327,116.858z" class="areabox itemhintfollow" title="宜蘭縣"/>
<path style="" d="M367.009,84.695c0.132,2.072,1.367,3.175,0.959,4.409c-0.407,1.235-0.143,1.929-1.245,2.624
	c-1.102,0.684-1.787,0.551-2.889,1.102c-1.102,0.551-0.682,0.408-2.479,1.918c-1.796,1.521-1.93,2.491-2.347,3.042
	c-0.166,0.221-0.389,0.541-0.575,0.839c-1.509-0.717-3.384-1.313-3.834-1.676c-0.575-0.463-3.021-0.827-3.77-0.927
	c0.891-2.445,2.17-5.819,2.17-5.819s2.756-6.801,4.222-9.369c0.233-0.396,0.54-0.959,0.915-1.621l0.463,0.1
	c0,0,3.307,0.286,4.409,1.796C364.109,82.624,366.864,82.624,367.009,84.695z" class="areabox itemhintfollow" title="新竹市"/>
<path style="" d="M499.408,52.18c1.378,1.929-3.583,3.031-6.063,4.685c-1.654-0.408-2.48,1.653-7.298,1.928
	c-4.827,0.276-6.755,0.551-6.899,0.97c-0.132,0.408-0.132,3.306-0.552,4.817c-0.406,1.51,1.522,2.48-1.102,4
	c-2.611,1.51-4.96,1.654-6.193,2.888c-1.236,1.234-2.073,3.174-3.032,4.133c-0.96,0.959-0.826,0.694-2.479,1.51
	c-1.652,0.837-1.235,0.837-3.307,2.348c-2.073,1.51-1.929,2.348-3.991,3.031c-2.07,0.684-4.959,1.102-6.899,1.786
	c-1.918,0.695-1.233,0.551-2.204,1.521c-0.959,0.97-1.918,0.684-2.336,2.072c-0.42,1.367-1.653,3.715-1.378,5.511
	c0.275,1.786,0.826,2.062-1.103,3.164c-1.928,1.102-4.554,3.583-4.554,3.583s-2.886,1.929-4.673,2.623
	c-1.686,0.639-4.573,1.411-4.926,1.5c0.396-0.915,0.728-1.675,0.781-1.918c0.145-0.552-1.232-1.786-1.51-2.337
	c-0.275-0.551-2.061-2.348-3.715-3.725c-1.653-1.377-0.551-2.337-0.693-3.857c-0.144-1.521,0-1.929,0-2.48
	c0-0.551,0.276-1.51,1.244-3.031c0.96-1.521-0.142-0.826-0.142-1.521c0-0.684-1.929-1.51-2.755-2.612
	c-0.827-1.102-1.103-0.959-2.48-2.061c-1.378-1.103-3.176-1.246-3.727-1.389c-0.551-0.133-2.469,1.245-4.122,1.521
	c-1.654,0.275-0.838-1.102-0.838-1.102s0,0-0.132-2.336c-0.134-2.348-0.42-1.797-0.685-3.451c-0.286-1.653-1.653-2.061-1.795-3.714
	c-0.145-1.654-0.409-3.593-0.551-5.247c-0.145-1.653,0.275-1.234,1.378-2.612c1.102-1.378,2.071-1.653,3.03-2.348
	c0.959-0.684,2.061-1.367,3.308-2.337c1.243-0.97,1.508-1.378,2.06-1.929c0.551-0.551,0.551-2.612,0.695-3.307
	c0.143-0.694-0.961-2.612-2.755-4.684c-1.798-2.072-5.656-3.031-6.758-3.582c-0.958-0.474-4.926-3.252-5.953-3.968
	c0.332,0.022,0.575,0.022,0.675,0.022c0.551,0,9.192-2.943,9.919-3.682c0.739-0.728,6.25-1.83,6.25-4.585s2.017-5.511,2.942-6.988
	c0.915-1.465,5.876-6.977,7.716-8.079c1.83-1.102,4.409-3.307,5.511-3.307c1.103,0,3.119,0.276,3.119,0.276
	c4.134,0,7.716,5.235,10.747,8.818c3.031,3.582,2.48,3.307,4.133,4.133c1.654,0.826,1.379,0.275,3.032,2.205
	c0.152,0.176,0.364,0.396,0.604,0.628l-0.053,0.054c-1.246,0.695-2.063-0.264-4.409,2.072c-2.349,2.337-2.349,3.583-2.349,3.583
	s0.971,2.205,1.247,3.45c0.275,1.234-0.276,2.887,1.508,3.571c1.799,0.695,3.594,1.103,4.961,2.205c1.388,1.102,0,2.491,3.45,2.491
	c3.449,0,5.787-0.551,6.338-1.653c0.551-1.102-0.133-1.653-0.419-3.45c-0.265-1.796,1.245-4.266,1.245-4.266l1.379-0.97
	c4.684,0.551,13.227-0.551,14.054,1.102c0.826,1.653,1.102,7.165,4.133,11.297C493.07,53.282,497.203,52.18,499.408,52.18z
	 M455.87,51.905c0.552-0.827-1.103-1.51-1.522-2.48c-0.406-0.97-0.682-2.337-1.233-3.99c-0.551-1.653-2.072-1.245-2.624-1.653
	c-0.551-0.418-2.336-2.755-3.438-4.552c-1.103-1.796-0.552-5.368-0.686-6.756c-0.142-1.367-4-2.061-4-2.061
	c-4.553-2.348-8.542,1.929-10.328,3.715c-1.795,1.796-2.49,3.307-2.623,4c-0.133,0.695,3.858,4.96,4.961,7.021
	c1.102,2.072-0.827,5.511-0.133,8.553c0.684,3.02,0.408,2.061,2.889,4.123c2.479,2.071,3.438,3.307,4.826,4.552
	c1.367,1.246,4.817,0.826,7.299-0.276c2.479-1.102,0.417-2.755,0.826-4.276c0.406-1.511,1.102-1.786,2.755-3.021
	C454.492,53.559,455.318,52.731,455.87,51.905z" class="areabox itemhintfollow" title="新北市"/>
<path style="" d="M471.853,36.75l-1.379,0.97c0,0-1.51,2.469-1.245,4.266c0.286,1.796,0.97,2.348,0.419,3.45
	c-0.551,1.103-2.889,1.653-6.338,1.653c-3.45,0-2.063-1.389-3.45-2.491c-1.367-1.102-3.162-1.51-4.961-2.205
	c-1.784-0.684-1.232-2.336-1.508-3.571c-0.276-1.246-1.247-3.45-1.247-3.45s0-1.245,2.349-3.583
	c2.347-2.336,3.163-1.377,4.409-2.072l0.053-0.054C461.325,31.899,467.609,36.253,471.853,36.75z" class="areabox itemhintfollow" title="基隆市"/>
<path style="" d="M454.348,49.425c0.42,0.97,2.074,1.653,1.522,2.48s-1.378,1.654-3.031,2.898
	c-1.653,1.235-2.349,1.51-2.755,3.021c-0.409,1.521,1.653,3.174-0.826,4.276c-2.481,1.102-5.932,1.521-7.299,0.276
	c-1.389-1.245-2.347-2.48-4.826-4.552c-2.48-2.062-2.205-1.103-2.889-4.123c-0.694-3.042,1.234-6.481,0.133-8.553
	c-1.103-2.061-5.094-6.327-4.961-7.021c0.133-0.694,0.828-2.204,2.623-4c1.786-1.786,5.775-6.063,10.328-3.715
	c0,0,3.858,0.694,4,2.061c0.134,1.389-0.417,4.96,0.686,6.756c1.102,1.797,2.887,4.134,3.438,4.552c0.552,0.408,2.073,0,2.624,1.653
	C453.666,47.088,453.941,48.455,454.348,49.425z" class="areabox itemhintfollow" title="台北市"/>
<a xlink:href="main-Taoyuan.html"><path style="" d="M430.42,104.25c-0.507,1.157-1.112,2.589-1.423,3.593c-0.551,1.786,0.419,4.541-0.265,6.338
	c-0.693,1.796-3.593,1.102-5.102,1.246c-0.509,0.044-1.412,0.209-2.471,0.375c-2.071,0.34-4.694,0.671-5.796,0.032
	c-1.654-0.959-4.685-3.582-5.236-4.133c-0.551-0.551-1.93-1.786-3.439-5.378c-1.521-3.572-2.347-4.96-2.622-8.399
	c-0.276-3.439,3.306-3.99-0.134-6.481c-3.449-2.469-5.247-4.122-5.653-4.409c-0.409-0.265-8.411-4.674-9.513-6.063
	c-1.103-1.367-3.714-4.817-3.858-5.225c-0.131-0.418-1.784-0.694-3.021-1.102c-1.243-0.418-3.448-1.103-5.102-2.348
	s-1.798-0.694-3.03-2.613c-1.236-1.939-2.757-3.593-2.757-3.593s-3.725-1.367-5.787-0.551l-0.517-0.232
	c1.156-2.568,3.77-5.864,3.911-6.327c0.188-0.551,2.757-3.857,2.757-3.857s12.312-9.005,14.516-9.744
	c2.205-0.727,4.223-1.102,6.427-2.567c2.204-1.466,4.783-2.756,5.885-2.756c0.904,0,4.551,0.132,6.116,0.166
	c1.027,0.716,4.995,3.494,5.953,3.968c1.102,0.551,4.96,1.51,6.758,3.582c1.794,2.072,2.897,3.99,2.755,4.684
	c-0.145,0.695-0.145,2.756-0.695,3.307c-0.552,0.551-0.816,0.959-2.06,1.929c-1.247,0.97-2.349,1.653-3.308,2.337
	c-0.959,0.694-1.929,0.97-3.03,2.348c-1.103,1.378-1.522,0.959-1.378,2.612c0.142,1.653,0.406,3.593,0.551,5.247
	c0.142,1.653,1.509,2.061,1.795,3.714c0.265,1.654,0.551,1.103,0.685,3.451c0.132,2.336,0.132,2.336,0.132,2.336
	s-0.816,1.377,0.838,1.102c1.653-0.275,3.571-1.653,4.122-1.521c0.551,0.143,2.349,0.286,3.727,1.389
	c1.378,1.102,1.653,0.959,2.48,2.061c0.826,1.102,2.755,1.928,2.755,2.612c0,0.694,1.102,0,0.142,1.521
	c-0.968,1.521-1.244,2.48-1.244,3.031c0,0.551-0.144,0.959,0,2.48c0.143,1.521-0.96,2.48,0.693,3.857
	c1.654,1.377,3.439,3.174,3.715,3.725c0.277,0.551,1.654,1.786,1.51,2.337C431.147,102.575,430.816,103.335,430.42,104.25z" class="areabox itemhintfollow" title="桃園市"/></a>
<path style="" d="M421.16,115.801l0.167,1.057c-0.167,0.883-0.551,2.766-0.861,3.792
	c-0.418,1.388,0.408,2.756-0.287,3.858c-0.682,1.102-0.406,2.072-1.509,2.898c-1.102,0.827-1.511,0.827-2.899,2.479
	c-1.367,1.654-2.756,2.888-3.858,4.277c-1.102,1.367-1.784,2.204-2.06,3.164c-0.188,0.65-0.374,1.698-0.474,2.304
	c-1.268-0.364-2.69,0.309-2.69,0.309l-5.512,0.143l-0.738-0.055c0.629-1.786,1.146-3.395,1.146-3.395s-0.275-1.234-0.408-2.061
	c-0.143-0.827-0.693-1.102-0.969-1.929c-0.275-0.827-3.031-1.786-3.991-2.336c-0.968-0.551-1.244-0.286-3.594-0.419
	c-2.335-0.132-4.673-0.683-5.51-0.683c-0.816,0-2.888,0.264-4.54,0.264c-1.653,0-2.338,0.287-3.583,1.521
	c-1.246,1.235-1.378,0.97-2.063,0.827c-0.692-0.143-1.939-1.796-2.204-3.857c-0.286-2.061,0.265-0.551,1.367-2.061
	c1.102-1.521,0.695-1.389,0.837-1.94c0.134-0.551-1.52-1.918-0.417-3.307c1.102-1.367,0,0,0.417-2.205
	c0.409-2.205-0.417-1.234-0.968-1.918c-0.552-0.695-2.339-2.491-2.481-3.174c-0.144-0.684-3.449-1.929-4.816-3.031
	c-1.388-1.102-2.349,0-4.828-0.551c-2.479-0.551-0.417-1.246-0.551-3.164c-0.131-1.94-2.071-5.511-3.032-6.757
	c-0.328-0.43-1.023-0.848-1.818-1.222c0.187-0.299,0.409-0.618,0.575-0.839c0.417-0.551,0.551-1.521,2.347-3.042
	c1.798-1.51,1.378-1.367,2.479-1.918c1.102-0.551,1.787-0.418,2.889-1.102c1.103-0.695,0.838-1.389,1.245-2.624
	c0.408-1.234-0.827-2.337-0.959-4.409c-0.145-2.071-2.899-2.071-4.001-3.582c-1.103-1.51-4.409-1.796-4.409-1.796l-0.463-0.1
	c1.995-3.604,5.599-10.349,6.063-12.521c0.088-0.418,0.264-0.893,0.497-1.389l0.517,0.232c2.063-0.816,5.787,0.551,5.787,0.551
	s1.521,1.654,2.757,3.593c1.232,1.918,1.377,1.368,3.03,2.613s3.858,1.929,5.102,2.348c1.236,0.408,2.89,0.684,3.021,1.102
	c0.145,0.408,2.756,3.858,3.858,5.225c1.102,1.389,9.104,5.797,9.513,6.063c0.406,0.287,2.204,1.939,5.653,4.409
	c3.439,2.491-0.143,3.042,0.134,6.481c0.275,3.439,1.102,4.828,2.622,8.399c1.51,3.593,2.889,4.827,3.439,5.378
	c0.552,0.551,3.582,3.174,5.236,4.133C416.466,116.473,419.089,116.142,421.16,115.801z" class="areabox itemhintfollow" title="新竹縣"/>
	<path style="" d="M303.482,281.854c0,0.971-1.223,4.387-2.678,4.387c-1.465,0-3.173,0-3.173,0
		s-2.922,1.697-4.389,2.193c-1.455,0.485-1.938-2.932-3.891-4.145c-1.951-1.224-2.447-2.193-2.688-2.932
		c-0.244-0.727,0.496-5.114,0.496-5.114c3.162-0.485,6.579-0.727,9.499,0.485C299.581,277.951,303.482,280.873,303.482,281.854z" class="areabox itemhintfollow" title="嘉義市"/>

                    <g>
	<path style="fill:none;stroke:#FFFFFF;" d="M250.327,304.247c0.133,0.1,0.826,0.495,1.818-1.312
		c1.103-2.018,2.205-4.961,2.382-6.978c0.187-2.028-2.568-4.597-2.755-7.902c-0.177-3.308-0.177-6.063-0.177-6.063l0.463-2.701
		l0.452-2.623c0,0-0.364-8.454-0.738-10.471c-0.364-2.029-1.654-4.96-0.177-7.352c1.467-2.392,3.483-4.222,3.858-6.063
		c0.364-1.84,1.466-3.119,2.018-6.062c0.551-2.943,3.857-6.801,4.596-8.267c0.728-1.467,2.382-4.222,3.307-6.426
		c0.154-0.375,0.354-0.738,0.573-1.08c1.048-1.676,2.645-2.998,3.098-4.067c0.551-1.29,1.102-2.018,2.391-4.045
		c1.278-2.017,2.757-7.892,4.035-9.92c1.29-2.017,2.942-4.035,3.856-5.511c0.926-1.466,2.205-5.137,2.205-5.137l3.307-4.232
		c0,0,4.409-3.119,5.147-4.585c0.738-1.477,0.551-2.392,0.551-3.13c0-0.728,2.392-5.875,3.67-7.341
		c0.981-1.124,3.341-2.777,4.409-4.222c0.344-0.463,0.552-0.894,0.552-1.29c0-1.653,2.027-4.959,2.027-6.25
		c0-1.29,0-2.755,0.178-4.409c0.187-1.653,1.477-2.392,2.941-3.307c1.467-0.915,3.672-6.8,4.045-7.352
		c0.364-0.551,5.137-10.096,5.137-10.096s1.587-2.303,3.264-4.751c1.015-1.455,2.051-2.964,2.799-4.067
		c2.028-2.943,3.681-2.943,3.858-5.698c0.187-2.756,1.102-5.324,2.943-8.079c1.84-2.756,3.492-8.267,4.045-8.454
		c0.551-0.188,3.306-3.67,4.772-4.596c1.466-0.915,7.528-5.511,8.63-6.239c1.103-0.738,5.886-4.596,6.25-5.886
		c0.099-0.375,0.409-1.235,0.772-2.26c0.891-2.445,2.17-5.819,2.17-5.819s2.756-6.801,4.222-9.369
		c0.233-0.396,0.54-0.959,0.915-1.621c1.995-3.604,5.599-10.349,6.063-12.521c0.088-0.418,0.264-0.893,0.497-1.389
		c1.156-2.568,3.77-5.864,3.911-6.327c0.188-0.551,2.757-3.857,2.757-3.857s12.312-9.005,14.516-9.744
		c2.205-0.727,4.223-1.102,6.427-2.567c2.204-1.466,4.783-2.756,5.885-2.756c0.904,0,4.551,0.132,6.116,0.166
		c0.332,0.022,0.575,0.022,0.675,0.022c0.551,0,9.192-2.943,9.919-3.682c0.739-0.728,6.25-1.83,6.25-4.585s2.017-5.511,2.942-6.988
		c0.915-1.465,5.876-6.977,7.716-8.079c1.83-1.102,4.409-3.307,5.511-3.307c1.103,0,3.119,0.276,3.119,0.276
		c4.134,0,7.716,5.235,10.747,8.818c3.031,3.582,2.48,3.307,4.133,4.133c1.654,0.826,1.379,0.275,3.032,2.205
		c0.152,0.176,0.364,0.396,0.604,0.628c2.371,2.236,8.655,6.591,12.898,7.087c4.684,0.551,13.227-0.551,14.054,1.102
		c0.826,1.653,1.102,7.165,4.133,11.297c3.031,4.133,7.164,3.031,9.369,3.031c1.378,1.929-3.583,3.031-6.063,4.685
		c-2.48,1.653-14.88,13.777-15.431,20.391c-0.551,6.613-1.104,21.493,0.551,26.453c1.653,4.96,1.653,6.338,3.307,8.267
		c1.652,1.929,1.929,2.48,1.377,4.409c-0.551,1.929-1.377,2.755-0.826,3.857c0.551,1.102,3.308,0.276,0.551,3.858
		c-2.755,3.582-6.613,4.96-4.684,6.338c1.929,1.377,5.511,0.827,3.857,2.204c-1.653,1.378-4.959,3.031-5.512,3.858
		c-0.551,0.826-1.377,2.479-1.929,3.306c-0.44,0.65-2.083,8.399-3.57,14.197c-0.386,1.521-0.773,2.898-1.114,3.99
		c-1.653,5.235-0.826,6.062-3.857,9.368s-6.889,3.583-8.817,8.267c-1.93,4.684,0.552,7.715-1.378,10.195
		c-1.929,2.48-3.857,6.889-3.857,9.369c0,2.48,2.204,4.96,2.755,6.063s1.654,1.929-0.275,3.582
		c-1.929,1.654-4.408,3.858-4.408,5.511s1.653,3.031,1.102,4.133c-0.551,1.102-2.205,8.542-4.96,14.329
		c-2.755,5.787-0.551,9.093-2.479,13.502c-1.93,4.41-1.93,12.675-2.756,13.503c-0.827,0.826-2.479,17.084-2.479,19.289
		c0,2.094-2.481,5.919-3.197,12.421c-0.046,0.353-0.077,0.717-0.11,1.081c-0.551,7.164-2.204,12.124-2.204,12.124
		s-4.409,7.99-5.787,11.022c-1.377,3.03-3.581,6.338-3.03,11.298c0.551,4.959,1.653,5.234,0.826,6.889
		c-0.826,1.653-1.377,3.307,0,4.408c1.378,1.103,3.307,2.204,1.103,3.308c-2.204,1.102-4.133,1.102-4.96,1.653
		c-0.827,0.551-3.031,0.826-4.96,3.856c-1.93,3.032-3.858,12.676-6.889,16.534c-3.031,3.857-4.134,7.164-5.787,8.817
		c-1.652,1.653-3.582,2.204-4.96,4.685c-1.378,2.479-2.479,0.552-2.204,4.684c0.275,4.134,0,9.095,0,9.095s1.378,1.652-10.747,8.542
		c-12.125,6.889-12.951,11.022-14.054,14.88s-7.716,21.217-8.817,25.351c-1.103,4.133-6.063,15.155-6.614,17.359
		c-0.551,2.205-1.377,12.4-0.826,14.88c0.551,2.481,1.103,7.441,1.653,11.574c0.551,4.134-0.275,6.338-0.275,7.715
		c0,1.378-0.275,4.409,0,5.236c0.275,0.826,1.652,3.858,0,5.511c-1.653,1.653-3.032,2.756-4.409,3.307
		c-1.378,0.551-1.653,0.826-2.48,4.409c-0.826,3.583-0.275,7.439,0.827,7.991c1.102,0.551,1.653,2.204,1.653,2.204
		s-2.204,0.551-4.133-1.378c-1.93-1.929-2.757-3.582-4.134-4.133c-1.378-0.551-3.857-1.102-6.613,0.551
		c-2.756,1.653-2.479,3.857-4.408,2.756c-1.93-1.103-3.583-3.857-3.583-3.857s0.551-2.48,0.275-4.409s-2.479-4.961-1.653-6.889
		c0.827-1.929,2.48-2.204,2.48-4.409s0-9.094-0.276-11.298c-0.275-2.205-3.856-11.573-4.685-13.502
		c-0.826-1.93-2.755-6.613-5.785-13.227c-3.032-6.613-7.992-7.164-12.4-11.85c-4.409-4.685-7.716-6.613-9.093-7.439
		c-1.379-0.827-1.654-4.134-1.654-4.134s-2.479-2.204-3.857-2.204c-0.595,0-1.466,0.21-2.458,0.265
		c-1.279,0.065-2.757-0.121-4.155-1.367c-2.48-2.205-8.817-8.542-11.574-12.124c-2.755-3.582-6.613-6.889-6.613-8.817
		s1.654-4.685,1.378-7.165s-3.858-7.99-3.858-7.99c-2.479-3.858-3.858-10.472-5.235-13.503c-1.378-3.031-3.858-7.164-4.684-11.849
		c-0.044-0.231-0.078-0.452-0.11-0.661c-0.717-4.057-0.795-4.432-2.37-7.055c-1.653-2.755-1.103-5.786-3.032-7.164
		s-1.654-0.826-3.031-2.479c-1.378-1.654,0.738-2.116,0.187-2.293c-0.551-0.188-5.511-2.205-6.249-4.045
		c-0.739-1.841-0.915-4.045,0.551-5.876c1.467-1.841,4.044-4.96,4.044-5.511s-0.737-0.551-1.102-2.204
		c-0.375-1.653-1.29-7.539,0.728-10.295c2.027-2.756,3.857-4.96,3.857-7.164c0-2.205,1.29-8.994,1.29-8.994"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M458.901,29.717c-1.246,0.695-2.063-0.264-4.409,2.072
		c-2.349,2.337-2.349,3.583-2.349,3.583s0.971,2.205,1.247,3.45c0.275,1.234-0.276,2.887,1.508,3.571
		c1.799,0.695,3.594,1.103,4.961,2.205c1.388,1.102,0,2.491,3.45,2.491c3.449,0,5.787-0.551,6.338-1.653
		c0.551-1.102-0.133-1.653-0.419-3.45c-0.265-1.796,1.245-4.266,1.245-4.266l1.379-0.97"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M442.367,30.412c0,0,3.858,0.694,4,2.061c0.134,1.389-0.417,4.96,0.686,6.756
		c1.102,1.797,2.887,4.134,3.438,4.552c0.552,0.408,2.073,0,2.624,1.653c0.552,1.653,0.827,3.021,1.233,3.99
		c0.42,0.97,2.074,1.653,1.522,2.48s-1.378,1.654-3.031,2.898c-1.653,1.235-2.349,1.51-2.755,3.021
		c-0.409,1.521,1.653,3.174-0.826,4.276c-2.481,1.102-5.932,1.521-7.299,0.276c-1.389-1.245-2.347-2.48-4.826-4.552
		c-2.48-2.062-2.205-1.103-2.889-4.123c-0.694-3.042,1.234-6.481,0.133-8.553c-1.103-2.061-5.094-6.327-4.961-7.021
		c0.133-0.694,0.828-2.204,2.623-4C433.825,32.341,437.814,28.064,442.367,30.412z"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M493.346,56.865c-1.654-0.408-2.48,1.653-7.298,1.928
		c-4.827,0.276-6.755,0.551-6.899,0.97c-0.132,0.408-0.132,3.306-0.552,4.817c-0.406,1.51,1.522,2.48-1.102,4
		c-2.611,1.51-4.96,1.654-6.193,2.888c-1.236,1.234-2.073,3.174-3.032,4.133c-0.96,0.959-0.826,0.694-2.479,1.51
		c-1.652,0.837-1.235,0.837-3.307,2.348c-2.073,1.51-1.929,2.348-3.991,3.031c-2.07,0.684-4.959,1.102-6.899,1.786
		c-1.918,0.695-1.233,0.551-2.204,1.521c-0.959,0.97-1.918,0.684-2.336,2.072c-0.42,1.367-1.653,3.715-1.378,5.511
		c0.275,1.786,0.826,2.062-1.103,3.164c-1.928,1.102-4.554,3.583-4.554,3.583s-2.886,1.929-4.673,2.623
		c-1.686,0.639-4.573,1.411-4.926,1.5c-0.023,0.011-0.034,0.011-0.034,0.011"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M404.066,40.056c0,0,0.087,0.066,0.24,0.166c1.027,0.716,4.995,3.494,5.953,3.968
		c1.102,0.551,4.96,1.51,6.758,3.582c1.794,2.072,2.897,3.99,2.755,4.684c-0.145,0.695-0.145,2.756-0.695,3.307
		c-0.552,0.551-0.816,0.959-2.06,1.929c-1.247,0.97-2.349,1.653-3.308,2.337c-0.959,0.694-1.929,0.97-3.03,2.348
		c-1.103,1.378-1.522,0.959-1.378,2.612c0.142,1.653,0.406,3.593,0.551,5.247c0.142,1.653,1.509,2.061,1.795,3.714
		c0.265,1.654,0.551,1.103,0.685,3.451c0.132,2.336,0.132,2.336,0.132,2.336s-0.816,1.377,0.838,1.102
		c1.653-0.275,3.571-1.653,4.122-1.521c0.551,0.143,2.349,0.286,3.727,1.389c1.378,1.102,1.653,0.959,2.48,2.061
		c0.826,1.102,2.755,1.928,2.755,2.612c0,0.694,1.102,0,0.142,1.521c-0.968,1.521-1.244,2.48-1.244,3.031
		c0,0.551-0.144,0.959,0,2.48c0.143,1.521-0.96,2.48,0.693,3.857c1.654,1.377,3.439,3.174,3.715,3.725
		c0.277,0.551,1.654,1.786,1.51,2.337c-0.054,0.243-0.385,1.003-0.781,1.918c-0.507,1.157-1.112,2.589-1.423,3.593
		c-0.551,1.786,0.419,4.541-0.265,6.338c-0.693,1.796-3.593,1.102-5.102,1.246c-0.509,0.044-1.412,0.209-2.471,0.375
		c-2.071,0.34-4.694,0.671-5.796,0.032c-1.654-0.959-4.685-3.582-5.236-4.133c-0.551-0.551-1.93-1.786-3.439-5.378
		c-1.521-3.572-2.347-4.96-2.622-8.399c-0.276-3.439,3.306-3.99-0.134-6.481c-3.449-2.469-5.247-4.122-5.653-4.409
		c-0.409-0.265-8.411-4.674-9.513-6.063c-1.103-1.367-3.714-4.817-3.858-5.225c-0.131-0.418-1.784-0.694-3.021-1.102
		c-1.243-0.418-3.448-1.103-5.102-2.348s-1.798-0.694-3.03-2.613c-1.236-1.939-2.757-3.593-2.757-3.593s-3.725-1.367-5.787-0.551"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M358.599,79.317c0,0,3.307,0.286,4.409,1.796c1.102,1.511,3.856,1.511,4.001,3.582
		c0.132,2.072,1.367,3.175,0.959,4.409c-0.407,1.235-0.143,1.929-1.245,2.624c-1.102,0.684-1.787,0.551-2.889,1.102
		c-1.102,0.551-0.682,0.408-2.479,1.918c-1.796,1.521-1.93,2.491-2.347,3.042c-0.166,0.221-0.389,0.541-0.575,0.839
		c-0.286,0.428-0.527,0.814-0.527,0.814"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M421.426,116.385c0,0-0.035,0.188-0.099,0.474c-0.167,0.883-0.551,2.766-0.861,3.792
		c-0.418,1.388,0.408,2.756-0.287,3.858c-0.682,1.102-0.406,2.072-1.509,2.898c-1.102,0.827-1.511,0.827-2.899,2.479
		c-1.367,1.654-2.756,2.888-3.858,4.277c-1.102,1.367-1.784,2.204-2.06,3.164c-0.188,0.65-0.374,1.698-0.474,2.304
		c-0.056,0.275-0.077,0.452-0.077,0.452"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M350.607,95.994c0,0,0.078,0.011,0.222,0.032c0.749,0.1,3.194,0.464,3.77,0.927
		c0.45,0.364,2.325,0.959,3.834,1.676c0.795,0.374,1.49,0.792,1.818,1.222c0.961,1.246,2.901,4.817,3.032,6.757
		c0.134,1.918-1.929,2.612,0.551,3.164c2.479,0.551,3.44-0.551,4.828,0.551c1.367,1.102,4.673,2.348,4.816,3.031
		c0.143,0.684,1.93,2.479,2.481,3.174c0.551,0.684,1.377-0.287,0.968,1.918c-0.417,2.205,0.685,0.837-0.417,2.205
		c-1.103,1.388,0.551,2.756,0.417,3.307c-0.142,0.551,0.265,0.418-0.837,1.94c-1.103,1.51-1.653,0-1.367,2.061
		c0.265,2.062,1.512,3.714,2.204,3.857c0.685,0.143,0.816,0.408,2.063-0.827c1.245-1.234,1.93-1.521,3.583-1.521
		c1.652,0,3.724-0.264,4.54-0.264c0.837,0,3.175,0.551,5.51,0.683c2.35,0.133,2.626-0.132,3.594,0.419
		c0.96,0.551,3.716,1.51,3.991,2.336c0.275,0.827,0.826,1.103,0.969,1.929c0.133,0.827,0.408,2.061,0.408,2.061
		s-0.518,1.609-1.146,3.395c-0.494,1.378-1.047,2.865-1.466,3.77c-0.969,2.071,1.103,3.725-1.244,3.45
		c-2.349-0.276-1.929-1.654-3.451-1.103c-1.51,0.551-2.756,2.348-3.02,2.755c-0.287,0.408-2.205,2.348-4.409,3.582
		c-2.204,1.235-3.043,0.97-4.827,2.48c-1.786,1.51-2.338,3.031-2.756,3.164c-0.42,0.143-1.102-1.511-3.44,0.286
		c-2.347,1.786-2.755,4.123-4.409,3.021c-1.65-1.103-0.142-1.235-2.754-2.756c-2.624-1.51-0.97-2.337-4.002-2.469
		c-3.03-0.143-2.755-0.551-3.581-0.286c-0.828,0.286-2.623-0.816-3.308-0.408c-0.682,0.408-1.521,0.827-1.521,1.654
		c0,0.827-0.684,1.51-1.366,2.479c-0.694,0.97,1.103,2.623-1.247,2.337c-2.346-0.265-5.918-0.265-7.306-1.103
		c-1.367-0.816-5.776-0.408-7.716-1.918c-1.918-1.521-3.858-3.307-5.919-4.144c-2.062-0.816-4.134-1.235-5.654-2.205
		c-1.512-0.959-2.469-1.367-3.571-2.337c-1.102-0.969-3.593-3.857-3.593-3.857l-2.89-4.96"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M401.177,140.082l5.512-0.143c0,0,1.423-0.672,2.69-0.309
		c0.551,0.155,1.067,0.484,1.432,1.146c1.246,2.204,0,5.092,2.491,6.063c2.469,0.959,2.755,2.204,4.959,2.061
		c2.205-0.143,4.818-1.929,5.776-1.377c0.739,0.418,1.951,0.275,2.922,0.794c0.297,0.165,0.572,0.396,0.805,0.727
		c0.969,1.367,0.275,2.062,1.52,2.205c1.236,0.132,3.44,0.132,3.991,0.551c0.551,0.408,0.551,0.408,2.888,1.785
		c2.349,1.378,3.041,0.684,4.553,1.378c1.51,0.694,2.205,1.653,3.714,1.377c1.521-0.275,0.971,0.132,2.755-0.827
		c1.797-0.959,1.654-0.408,2.625-2.205c0.968-1.796,2.621-3.714,2.621-3.714s0.816-0.838,3.021,0.551
		c2.204,1.367,3.45,1.367,4.276,2.336c0.827,0.97,2.071,1.521,3.174,1.521c0.981,0,6.811,0,8.136,0c0.165,0,0.265,0,0.265,0"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M358.774,283.602c-1.498,0.154-1.158,0.342-4.309-0.23
		c-3.858-0.695-5.379-1.103-5.787-1.103c-0.406,0-2.347,0.143-3.308-1.797c-0.957-1.918-1.102-0.265-1.508-3.715
		c-0.42-3.449-0.972-10.063-0.972-10.063s0.42-1.918-1.102-2.469c-1.521-0.552-2.888-1.797-3.989-1.797
		c-1.103,0-3.858,0.826-5.512-0.275c-1.653-1.103-2.624-2.072-3.306-1.521c-0.696,0.551-4.145,1.521-4.145,1.521
		s-4.409,0.826-5.093-1.654c-0.684-2.479-1.521-4.541-1.379-5.093c0.145-0.551,4.268-1.653,1.93-3.725
		c-2.337-2.072-2.623-2.623-2.623-2.623l1.939-3.021c0,0,2.337-1.653,1.785-3.592c-0.551-1.918-2.071-2.756-1.652-4.123
		c0.076-0.243,0.143-0.463,0.208-0.65c0.31-0.893,0.529-1.246,0.763-1.697c0.264-0.552,0.682-0.276,1.102-1.51
		c0.407-1.246-0.287-2.491-0.971-3.174c-0.682-0.684-1.379,0.418-2.622-2.48c-1.236-2.898-0.816-4.816-0.552-5.368
		c0.286-0.551,0.286-0.97,0.838-3.307c0.551-2.348,0.551-2.072,1.367-4c0.838-1.929,1.52-2.062,0.143-3.307
		c-1.379-1.246-3.308-3.031-3.858-5.655c-0.551-2.612,1.511-2.755-0.551-4.96c-0.308-0.331-0.583-0.595-0.827-0.804
		c-1.377-1.202-1.721-0.773-1.377-1.952c0.408-1.367,0.826-1.653,0-2.469c-0.828-0.838-1.379-1.94-2.612-3.307
		c-1.246-1.388-3.041-3.45-3.041-3.45l-3.021-4.96l-1.938-2.48l-4.123-3.99"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M426.937,148.349c0,0,0.551,5.368-0.275,6.613c-0.826,1.245-1.653,2.898-2.204,3.582
		s-1.653,1.377-2.479,2.336c-0.827,0.97-1.512,0.97-1.93,2.205c-0.42,1.245,0.551,0.143-0.42,2.072
		c-0.958,1.929,0.287,1.377-1.509,3.031c-1.798,1.653-2.755,2.347-3.164,3.45c-0.419,1.102-0.142,2.061,0.134,3.307
		c0.275,1.234,0.275,2.061-0.275,2.204c-0.553,0.132,0,0.816-1.104-0.418c-1.102-1.234-0.826-2.072-1.798-1.654
		c-0.957,0.419-0.406,0.552-2.204,1.235c-1.785,0.694-2.887,1.653-3.57,2.491c-0.694,0.816-1.654,0.408-1.245,1.367
		c0.406,0.97,0.275,0.551,1.378,2.204c1.102,1.654,1.233,2.348,2.622,3.307c1.367,0.97,1.235,0.695,2.204,1.654
		c0.96,0.97,2.469,2.348,2.205,2.899c-0.287,0.551,0.133-0.551-1.104,1.377c-1.243,1.929-0.692,2.072-1.794,3.582
		c-1.103,1.511-1.653,2.348-2.9,3.307c-1.233,0.959-2.205,1.103-2.336,2.348c-0.134,1.235-0.42,1.654-0.42,2.756s0,0.551,0,2.205
		c0,1.653,0.551,1.786,0.42,3.307c-0.134,1.51,0.826,3.438,0.275,4.817c-0.551,1.377-1.929,4.266-1.929,4.266
		s-0.551,3.593-0.551,4.552c0,0.959,0.275,1.653-0.685,3.031c-0.97,1.378-0.417,3.725-0.694,5.235
		c-0.275,1.51-1.652,3.858-2.755,5.236c-1.102,1.377-3.45,0.132-1.929,2.623c1.52,2.469,0.131-0.143,1.52,2.469
		c1.368,2.623,2.063,2.623,2.756,4.145c0.686,1.51,1.653,0.815,0.961,2.755c-0.695,1.918-1.512,2.204-2.063,3.715
		c-0.551,1.51,0.551,3.306,0.551,4.001c0,0.683-0.551,0.551-1.245,2.755c-0.695,2.204,0.552,0.551-0.695,2.204
		c-1.233,1.654-0.815,1.235-2.755,2.755c-1.918,1.51-3.571,3.715-4.122,3.715s-1.94-0.826-2.622,0.551
		c-0.686,1.378-1.236,3.857-1.378,4.685c-0.145,0.826,2.346,1.377-1.102,2.48c-3.452,1.102-3.583,1.652-5.37,1.652
		c-1.796,0-2.755-0.551-3.449-0.144c-0.695,0.42-0.275,1.104-0.96,2.072c-0.692,0.971-0.551,3.308-0.551,3.858
		s-0.838,2.336-2.756,3.582c-1.938,1.245-0.551,2.062-2.622,1.245c-2.072-0.837-1.233-0.837-2.337-1.388
		c-1.102-0.551-0.551-0.816-4.002-1.511c-3.448-0.694-1.377-1.102-4.551-0.958c-0.575,0.021-0.992,0.054-1.323,0.087"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M315.205,201.398c0,0,2.755,0.132,3.988,0.551c1.236,0.408,3.728,1.786,4.685,2.337
		c0.961,0.551,0.827,0.418,4.554,0.275c3.713-0.143,4.122-0.143,5.367-0.143s1.929,0.143,4.267-1.234
		c2.347-1.378,1.653,1.377,3.041-2.888c1.368-4.276,2.205-5.654,2.205-5.654s0.132-0.551,0.683-0.276
		c0.551,0.276,2.479,0.419,4.278-0.132c1.784-0.551,5.641-2.072,6.326-2.623c0.693-0.551-0.408-0.551,1.939-1.653
		c2.336-1.102,1.367-1.521,3.988-1.786c2.626-0.286,3.308,0,4.409-0.143c1.103-0.143,1.378,0.276,3.308-1.377
		c1.929-1.653,2.204-2.205,2.887-2.48c0.696-0.275,4.695-2.899,5.247-3.031c0.551-0.132,2.889-2.072,3.164-2.755
		c0.275-0.684,0.551-1.235,1.245-1.786c0.685-0.551,2.469,0.132,4.267-0.837c1.796-0.959,3.714-2.205,3.714-2.205
		c0.087-0.022,0.674-0.065,4.144-0.265c4.542-0.286,4.408,0.132,5.645-0.694c1.234-0.827,3.438-1.51,3.438-1.51
		s3.041-1.797,3.45-0.695c0.408,1.102,1.51,0,2.347,0c0.816,0,1.918-1.377,2.89-0.959c0.968,0.408,4.275,2.205,4.275,2.205"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M320.021,237.628c-0.022,0.011-0.044,0.022-0.067,0.045
		c-0.627,0.33-0.661,1.719-1.587,0.65c-0.958-1.103-2.898-3.175-3.713-3.726c-0.838-0.551,0.131-2.072-2.625-1.929
		c-2.755,0.143-7.296-0.827-9.368-1.245c-2.07-0.408-4.133-1.103-5.787-1.103c-1.653,0-7.021-1.367-7.021-1.367l-5.655,2.337
		c0,0-8.959,2.756-10.471,2.204c-1.51-0.551-4.959-3.03-7.439-2.336"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M252.51,279.37c0,0,3.176,0.143,4.542,0.143c1.389,0,5.378-0.827,6.205-1.378
		c0.827-0.551,3.032-0.683,4.684-2.072c1.654-1.367,2.756-2.062,4.686-3.438c1.928-1.378,1.797-1.378,2.899-3.031
		c1.102-1.653,3.162-3.163,3.162-3.163s0.961-1.389,2.614-1.653c1.652-0.287,7.856-2.348,7.856-2.348s4.819-0.694,5.37-0.694
		s0.286-2.338,2.49-0.817c2.204,1.511,2.611,0.96,4.123,1.786c1.52,0.826,3.172,1.521,6.204,2.887
		c3.03,1.389,6.063,3.451,7.572,2.491c1.521-0.969,1.521-1.52,2.622-1.652c1.103-0.143,0.827-0.552,2.757,1.102
		c1.929,1.653,2.338,2.469,4.277,1.918c1.918-0.551,3.989-1.102,4.96-1.367c0.958-0.286,2.06-0.286,1.918-1.938
		c-0.134-1.654,0.837-3.99,0.837-3.99"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M358.874,283.515c0,0-0.032,0.032-0.088,0.087h-0.012
		c-0.494,0.485-2.787,2.623-4.861,3.351c-2.335,0.828-2.335,2.072-3.723,2.623c-1.367,0.553-4.409,2.889-4.675,3.308
		c-0.286,0.407-1.797,1.511-2.49,3.163c-0.685,1.653-0.551,1.378-1.919,3.164c-1.388,1.796,0.133,2.204-2.755,3.041
		c-2.899,0.816-2.49,0.266-3.858,1.235c-1.388,0.969-0.97,0.826-2.073,2.204c-1.102,1.378,0,0.97-1.784,2.072
		c-1.797,1.102-2.204,1.367-3.593,1.786c-1.367,0.418-0.816,0-2.755,0.969c-1.918,0.96-1.512-0.286-2.47,0.96
		c-0.971,1.245-0.971-0.552-1.246,2.348c-0.275,2.888,0.551,2.469-0.275,4.122c-0.828,1.652-0.684,0.551-0.97,2.348
		c-0.265,1.796,0.694,2.612,0.419,3.715c-0.277,1.102,0.275,1.102-1.104,2.898c-1.378,1.797-1.103,1.93-2.335,3.307
		c-1.247,1.378-0.972,1.51-2.899,3.715c-1.93,2.204-2.898,1.939-3.714,4.276c-0.838,2.336-0.286,2.204-1.798,4.133
		c-1.51,1.93-3.03,4.134-5.235,5.512c-2.204,1.377-4.541,3.163-6.48,4.96c-1.917,1.797-3.307,4.409-4.123,5.367
		c-0.837,0.971-1.652,2.624-2.899,4.276c-1.243,1.653-1.796,2.757-2.755,3.439c-0.959,0.694-0.143,0.144-2.611,1.653
		c-2.49,1.521-2.073,1.389-3.727,1.653c-1.653,0.286-2.479,0.143-3.989,0.286c-1.522,0.133,0.406-0.144-3.45,0.408
		c-3.858,0.551-3.032-0.143-5.787-0.143s-3.174,0.418-4.54-0.685c-1.389-1.102-1.522-1.786-2.756-1.786
		c-1.246,0-0.286-0.143-1.246,0c-0.618,0.089-1.972,0.067-2.866,0.023c-0.495-0.012-0.848-0.023-0.848-0.023"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M319.327,320.295l-5.224-1.797c0,0-2.074,1.797-4.003,2.205
		c-1.929,0.418-3.307,1.797-4.684,0c-1.379-1.786-1.93-4.123-1.93-5.645c0-1.52,0.551-2.204,0.275-3.306
		c-0.275-1.103-0.551,0.275,0.42-2.757c0.959-3.03,0.816-3.988,0.551-4.408c-0.286-0.419,0.959-0.419-0.837-1.928
		c-1.787-1.511-3.716-6.063-4.96-6.758c-1.236-0.683-1.236-0.683-2.47-0.958c-1.246-0.275-1.938-1.104-3.593-0.694
		c-1.653,0.419-4.959-0.552-5.368-0.552c-0.407,0-4.552,1.246-4.552,1.246s-4.123,0-5.093,0.551
		c-0.969,0.551-2.887,1.378-3.583,1.929c-0.692,0.551-0.692-0.826-2.755,1.929c-2.061,2.756-2.347,2.756-4,3.858
		c-1.653,1.102-1.51,0.826-2.613,1.51c-1.102,0.694-2.897,1.939-3.03,2.898c-0.132,0.959-0.277,2.898-2.481,2.612
		c-2.205-0.265,0.41,0.97-2.755-0.407c-3.162-1.379-4-2.348-4-2.348l-2.316-3.229l-0.022-0.022"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M290.956,431.211c0,0-0.286-0.033-0.673-0.43c-0.353-0.364-0.793-1.058-1.125-2.326
		c-0.692-2.623-0.826-2.755-0.826-3.307c0-0.551,0.42-0.286,1.235-1.652c0.838-1.39,1.389-1.94,1.653-2.348
		c0.286-0.409,1.94-0.695,1.653-2.481c-0.264-1.784,0.287-2.887-0.133-4.132c-0.418-1.246-2.205-2.899-1.654-4.267
		c0.551-1.389,0.971-6.348,0.828-7.164c-0.144-0.838,2.063-4.277,2.063-5.654c0-1.378,0.692-4.685,0.692-6.063
		s0.826-2.347,0.96-4.684c0.142-2.338-0.685-3.583,0.142-4.542c0.827-0.97,0.145-0.551,1.512-1.245
		c1.389-0.694,4.275-1.103,6.479-1.653c2.205-0.551,2.205,0.275,3.858,0.143c1.653-0.143,3.03-0.143,3.857-1.388
		c0.826-1.235,0.971-1.918,0.971-1.918s1.654-2.348,2.756-2.348c1.103,0,2.06,0.275,4.541,0.275c2.479,0,1.521,0.275,5.093,0.132
		c3.593-0.132,5.797-0.959,5.797-0.959s-0.551-2.348,2.062-0.826c2.613,1.521,7.99,4.276,7.99,4.276s1.929,0.132,2.756-0.837
		c0.826-0.96,1.235-3.308,1.652-2.889c0.42,0.418,3.583,1.653,3.583,1.653"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M435.06,287.503l-3.021-0.551c0,0-2.204,0.551-3.307,0.971
		c-1.102,0.408-2.897,0.551-2.897,1.785s-2.204,3.582-1.512,5.512c0.685,1.929,1.787,3.173,1.367,4.276
		c-0.407,1.102-1.509,2.336-1.784,2.888s-1.378,1.785-1.929,2.624c-0.552,0.815-2.205,2.755-2.205,3.438
		c0,0.685,1.378,3.99,0.551,5.38c-0.826,1.366-2.613,4.816-3.164,5.511c-0.552,0.684-0.286,0.407-1.244,3.307
		c-0.96,2.888-1.512,3.572-2.205,4.96c-0.695,1.367-0.959,1.786-0.959,3.307c0,1.51,0,0.959,0.264,2.888
		c0.287,1.929,0.42,1.786-1.233,2.204c-1.653,0.419-3.726,2.205-4.409,1.93s-1.234-1.93-2.479-3.583
		c-1.246-1.653-0.145-0.969-1.798-2.755c-1.652-1.786-4.265-2.755-5.225-4.134c-0.969-1.378-0.552-0.275-1.939-3.03
		c-1.367-2.757,0.837-1.521-1.367-2.757c-2.204-1.233-1.653-1.929-3.173-1.52c-1.522,0.418,0.275,1.102-2.073,0.693
		c-2.335-0.407-1.653,0.408-3.021-0.826c-1.389-1.234-3.448-2.756-3.448-2.756s-2.899-0.551-3.583-1.377
		c-0.684-0.828-0.684,0.551-1.102-1.654c-0.42-2.204,0-3.45-0.42-4.266c-0.407-0.837,0.42-0.971-0.683-2.348
		c-0.685-0.859-0.837-1.08-1.06-1.521c-0.131-0.265-0.286-0.618-0.594-1.234c-0.826-1.653,0.417-0.552-0.826-1.653
		c-1.247-1.103,1.378-0.275-1.93-1.654c-3.307-1.378-4.685-1.796-4.685-1.796s-0.275-1.234-0.275-1.654
		c0-0.407,1.929-3.02,1.929-3.02s1.795,0.408,1.929-1.246c0.133-1.652,0.684-1.928,0.552-2.348
		c-0.133-0.407-1.103-4.122-1.103-4.122"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M341.14,399.07c0,0.032,0.1,0.375,0.232,1.962c0.287,3.175-1.367,3.175-2.339,4.961
		c-0.968,1.784-2.621,3.725-3.437,5.643c-0.839,1.939-1.39,3.042-1.39,4.145s-1.787,1.785-0.815,3.163
		c0.958,1.378,2.061,1.929,1.366,4c-0.684,2.062,0.419,3.715,0.839,4.409c0.406,0.685,1.784,5.776,2.06,6.47
		c0.275,0.695,0.145-0.275,1.246,1.654c1.103,1.929,2.204,0,1.653,2.899c-0.551,2.888-1.939,3.306-2.755,3.856
		c-0.838,0.553-2.49-0.693-2.49,2.337c0,3.032,0.551,4.542,0.968,4.828c0.42,0.265,0.42,0.408,1.378,0.551
		c0.96,0.133,3.858,1.102,4.134,2.612s0,1.511-0.551,2.756c-0.552,1.245-1.234,1.929-0.133,3.307
		c1.104,1.378,1.654,1.929,2.471,3.164c0.837,1.245-0.134,1.388,1.102,2.204c1.244,0.838,1.653,0.419,3.857,1.939
		c2.205,1.51,4.826,2.061,4.826,2.061h1.93"/>
	<path style="fill:none;stroke:#FFFFFF;" d="M375.274,306.517l-2.204,1.378c0,0-0.969,0.419-2.898,1.235
		c-1.929,0.837-1.653,0.97-3.308,1.796c-1.652,0.827-3.712,3.031-4.265,3.857c-0.551,0.828-2.073,1.797-2.49,2.205
		c-0.409,0.407-1.787,1.653-2.063,2.061c-0.275,0.419-0.275,1.39-0.826,2.348c-0.551,0.96-0.683,3.032-0.683,3.45
		c0,0.408,0.266,0.552-0.971,1.919c-1.234,1.388-2.071,1.388-2.756,2.348c-0.683,0.958,0.551,1.929,0.551,3.306
		c0,1.378-0.275,3.582-0.417,4.408c-0.134,0.828,0.142,0.553-0.134,2.062c-0.275,1.521-0.969,0.839-1.233,3.043
		c-0.286,2.204-0.286,1.102-0.286,3.02c0,1.94-0.409,3.308-0.409,4.409c0,1.103,1.378,0.143-0.275,2.204
		c-1.653,2.072-3.032,2.491-3.583,3.308c-0.551,0.837-0.826,1.244-1.377,2.49c-0.552,1.235-2.07,3.715-1.653,5.225
		c0.42,1.521,1.377,4.552,1.929,5.511c0.551,0.97,2.9,2.898,2.9,2.898s0.131,1.379,0.406,2.613c0.056,0.275,0.077,0.605,0.056,0.959
		c-0.045,1.256-0.462,2.766-0.462,2.766s2.335,2.756,2.61,3.176c0.275,0.407,1.653,1.102,1.653,1.102l2.613,3.307
		c0,0,0,2.612,0,3.57c0,0.971-0.408,5.38-0.959,5.798c-0.551,0.408-2.205,0.684-3.449,1.235c-1.235,0.551-1.235,2.072-3.164,2.204
		c-1.93,0.133-2.347,0.97-3.449,1.102c-1.102,0.133-2.613-0.551-3.164,0.133c-0.255,0.331-0.364,0.1-0.375,0.11v-0.011"/>
</g>
<g class="areabox itemhintfollow" title="澎湖縣">
	<path style="" d="M108.027,347.07l-2.062-0.273c0,0-2.888,0.548-3.163,1.168c-0.275,0.62,2.268,2.614,2.268,2.819
		c0,0.206-0.824,2.406-1.375,2.544c-0.55,0.139-1.788,1.651-1.788,1.651s-1.032,0.755-1.032,1.101c0,0.342,0.826,1.373,0.826,1.373
		l2.751,0.345c0,0,1.786-1.512,2.062-1.649c0.275-0.138,3.85-1.033,3.85-1.033l0.688,0.413c0,0,0,0.346-0.62,0.964
		c-0.618,0.619-1.307,1.647-2.75,2.268c-1.445,0.62-1.445,0.62-1.445,0.62s-0.687-0.551-0.962-0.551
		c-0.274,0-2.543,0.139-2.543,0.413c0,0.275,0.687,1.235,0.894,1.718c0.206,0.481,0.206,1.307,1.581,1.789
		c1.374,0.48,3.577,0.412,3.782,0.068c0.206-0.345,0.619-0.551,1.237-0.551c0.62,0,3.713-0.825,3.919-0.825s3.921-0.066,3.921-0.066
		s2.131,0.137,2.269,0.687c0.136,0.549-0.482,1.513-0.963,1.925c-0.481,0.413-0.138,0.413-0.687,1.512
		c-0.552,1.101-1.308,1.995-1.238,2.751c0.068,0.757,1.58,1.994,0.137,2.063c-1.444,0.069-2.82-0.344-2.82-0.344
		s-1.169-2.133-2.27-1.857c-1.1,0.275-3.094,0.205-2.956,1.17c0.138,0.962-0.069,2.132-0.069,2.132s-0.069,0.412-0.824,0.481
		c-0.757,0.067-0.963,0.274-0.963-0.345s0.55-1.513,0.343-2.338c-0.206-0.825,1.169-1.719-0.962-1.512
		c-2.131,0.206-2.475,0.48-2.888,0.893c-0.413,0.413-0.206,0.688-0.962,0.825c-0.756,0.138-1.238,1.307-1.788-0.345
		c-0.55-1.648-0.413-1.855-0.756-2.543c-0.345-0.688-0.963-0.688-1.444-2.063c-0.481-1.375-0.551-2.614-0.551-3.093
		c0-0.483-0.137-1.376-0.207-1.584c-0.068-0.205-1.925,1.376-2.682,2.339c-0.755,0.963-2.406,3.85-2.406,4.539
		c0,0.687,3.988,0.549,3.988,0.549s0.688,0.412,0.688,1.305c0,0.896,0.344,1.79,0.894,2.202c0.549,0.414,0.618-1.307,1.581,0.825
		c0.963,2.13,2.613,2.956,3.438,2.956c0.826,0,0.894-0.343,1.582-0.343c0.687,0,1.374,1.994,1.788,2.543
		c0.412,0.551,0.481,1.377,2.818,1.789c2.338,0.411,4.058-0.825,4.54-1.169c0.48-0.345,2.13-0.482,3.3,0
		c1.169,0.48,2.818,0.894,3.369,1.031c0.549,0.138,1.925-1.995,1.925-2.338c0-0.345-0.412-0.894-0.344-1.789
		c0.068-0.893-0.344-2.198-0.206-2.956c0.138-0.756,0.825-1.719,1.375-2.613c0.549-0.893,2.199-2.682,2.545-2.819
		c0.343-0.138,4.056-1.099,4.056-1.099s2.889-0.207,3.507-1.308c0.62-1.099,2.545-4.881,3.094-5.225
		c0.549-0.345,3.164-0.894,3.438-0.825c0.275,0.067,5.432,0.893,5.432,0.893l3.302-0.139c0,0-0.138,1.173-0.276,1.651
		c-0.137,0.481,0.344,1.584,1.239,1.584c0.893,0,3.85-0.622,3.85-0.622l2.063-1.167c0,0,0.688-2.269,0.895-2.681
		c0.206-0.413-2.819-1.651-2.819-1.651l-1.374-2.201c0,0-0.482-2.063-0.621-2.544c-0.138-0.481-1.442-3.919-1.375-4.125
		c0.069-0.206,0.688-2.199,0.688-2.199s-0.413-1.583-1.099-1.996c-0.689-0.411-1.169-4.125-1.169-4.125l-1.238-0.273
		c0,0-1.443,0.823-1.514,1.373c-0.068,0.551,0.207,1.583,0.207,1.927c0,0.343-1.238,2.543-1.238,2.543l-1.1,1.1l-1.925-2.749
		c0,0,0.411-3.85,0.48-4.057c0.07-0.205,1.375-2.407,1.375-2.407l-1.1-1.237l-3.233-0.069c0,0-0.549,1.031-0.892,1.444
		c-0.345,0.412-1.924,1.237-2.064,1.72c-0.136,0.48-0.894,1.374-1.031,2.131c-0.136,0.756-0.412,1.994-0.412,1.994l-0.619,0.205
		l-0.689-2.132c0,0-1.304,0.414-1.304,0.621c0,0.205-0.275,1.581-0.481,2.199c-0.206,0.619-0.757,1.925-1.102,2.682
		c-0.342,0.758-2.131,1.926-2.131,2.476c0,0.551-0.62,1.238-0.62,1.238l0.139-2.819c0,0-0.963-1.308-0.344-2.132
		c0.619-0.825,0.964-1.651,0.964-1.856c0-0.206-0.552-0.963,0.137-1.443c0.687-0.481,1.443-1.308,1.443-1.308l-0.895-1.511
		c0,0-1.1-0.276-1.58-0.07c-0.482,0.206-2.062,1.376-2.268,1.993c-0.207,0.619-0.482,0.964-0.482,0.964l-1.789-0.826
		c0,0-0.273-1.512-0.618-1.1c-0.345,0.412-1.1,1.1-1.1,1.1s-1.445-0.207-1.79,0.07c-0.342,0.275-0.342,0.963-0.479,1.168
		c-0.139,0.206-0.826,1.1-0.413,1.513c0.413,0.413,0.893,0.62,1.1,1.169c0.206,0.551,0.345,1.102,0.345,1.719
		c0,0.618-0.139,1.513-0.345,1.719c-0.207,0.205-2.131,0.205-2.131,0.205s-1.306-0.205-1.306,0.139c0,0.345,0.273,1.925,0.413,2.613
		c0.138,0.688,0,1.374-0.139,1.857c-0.136,0.48-0.961,1.167-0.961,1.167s-0.138-0.549-0.276-1.031
		c-0.138-0.479-0.343-1.719-0.755-1.65c-0.414,0.069-0.896,0.14-0.896,0.14l-1.237-1.102c0,0-1.169,0.205-1.308-0.206
		c-0.135-0.412-0.273-0.342,0.277-1.514c0.548-1.168,1.307-1.719,1.101-2.405c-0.207-0.688-1.101-2.063-1.101-2.063l-2.339,0.688
		c0,0-1.58,0.687-1.58,1.443S108.027,347.07,108.027,347.07z"/>
	<path style=";" d="M98.607,314.411c0,0,0.482,3.232,0.413,3.438c-0.068,0.205,1.582,1.925,1.856,2.268
		c0.275,0.344,1.169,1.858,2.063,1.445c0.894-0.414,3.094-1.994,3.576-2.477c0.48-0.482,1.375-2.818,1.719-3.094
		c0.343-0.275,2.75-0.481,2.887,0.207c0.139,0.687,0.481,2.542,0.481,2.818c0,0.275-0.411,0.895,0.207,1.512
		c0.619,0.619,0.757,0.895,1.238,1.721c0.482,0.823,0.893,1.718,1.444,2.199c0.549,0.481,1.305,1.031,1.65,1.513
		c0.343,0.481,0.687,0.205,0.687,1.445c0,1.237,0.206,1.718,0,2.062s-1.305,1.308-1.305,1.308s-0.965,0.136-0.138,0.822
		c0.824,0.689,1.237,0.414,1.924,0.76c0.689,0.342,1.719,0,1.858,0.754c0.138,0.756-0.345,1.309,0.206,1.79
		c0.55,0.48,0.343,0.55,1.512,1.028c1.17,0.483,0.824,0.826,1.789,0.483c0.961-0.345,1.443-0.206,1.443-0.962
		s1.031-0.688-0.07-1.584c-1.099-0.892-1.992-0.892-1.992-1.855c0-0.962-0.139-1.514,0.413-2.337
		c0.549-0.826,1.307-1.65,0.755-2.337c-0.549-0.688-0.755-0.896-1.58-1.514c-0.826-0.619-1.307-1.65-1.376-2.338
		c-0.068-0.688-0.826-0.48,0-1.237c0.824-0.758,0.55-0.345,2.75-1.581c2.199-1.239,2.132-0.895,2.269-1.651
		c0.14-0.756,0.618-3.369,0.618-3.369l-3.436-3.437c0,0,0.275-0.689-1.169-0.619c-1.445,0.068-3.438-1.032-3.438-1.032l-1.514-0.964
		l-3.851,0.138c0,0-2.269-0.413-2.542-0.068c-0.275,0.343-1.996,0.619-3.095,0.962c-1.1,0.345-3.851,0.759-3.851,0.759l-2.063,1.167
		L98.607,314.411z"/>
	<path style="" d="M85.75,318.191c-0.275,0-2.269,1.307-1.582,1.651s1.857,0.687,1.444,1.101
		c-0.413,0.412-1.032,0.894-1.238,0.962c-0.206,0.07-1.375,0-1.856,0.481c-0.48,0.481-1.168,2.131-1.65,2.819
		c-0.48,0.687-1.649,1.788-1.649,1.995c0,0.206-0.069,1.373-0.069,1.648s-1.444,1.102-1.169,1.649
		c0.276,0.552,1.169,0.825,1.307,1.307c0.138,0.482-0.55,1.996-0.207,2.545c0.345,0.552,1.101,1.102,1.444,1.513
		c0.344,0.412,0.069,1.099-0.137,1.376c-0.207,0.275-0.688,1.169-0.963,1.582c-0.275,0.411-0.826,1.442-0.826,1.787
		c0,0.344-0.275,0.962,0.069,1.443s0.412,0.689,0,0.689s-2.063-0.553-2.2-0.346c-0.137,0.206-0.55,1.513,0,1.857
		c0.549,0.343,2.612,1.786,2.612,1.994c0,0.205-0.619,0.618-0.344,1.581c0.275,0.963,0.068,1.102-0.55,2.063
		c-0.618,0.963-1.169,1.375-1.994,2.063c-0.825,0.688,0.275,1.442-2.131,1.167c-2.406-0.274-4.263-1.443-5.088-0.687
		c-0.826,0.756-2.545,2.133-2.888,2.407c-0.343,0.273-1.031,2.063-1.031,2.063s-1.032-0.139,0.619,0.412
		c1.651,0.549,2.958,0.411,4.47,0.136c1.513-0.273,2.269-0.273,3.299-0.687c1.032-0.412,0.62-1.651,3.37-1.032
		c2.751,0.62,1.513,0.207,2.751,0.62c1.237,0.412,5.157,0.48,5.57,0.48c0.412,0,2.2-1.581,2.2-1.581s0-1.031-0.688-1.101
		c-0.688-0.069-1.857-0.687-1.925-0.892c-0.069-0.209-0.756-1.791-0.756-1.791l-0.894-2.749c0,0,0.756-0.826,0.756-1.788
		s-0.618-1.648,0.138-2.613c0.756-0.962,1.581-1.787,1.581-1.994c0-0.206,2.269-1.031,2.063-1.925
		c-0.207-0.894-0.413-2.063-0.55-2.611c-0.137-0.551-0.345-2.888-0.345-3.233c0-0.344,0.62-1.924,0.757-2.337
		c0.138-0.414,0.962-1.856,0.962-1.856s0.962-0.618,2.476-0.962c1.512-0.345,2.682-0.62,2.682-0.62s0.481-1.307,1.444-1.925
		c0.962-0.619,0.894-2.682,0.894-2.682s-0.619-1.444-1.994-0.688c-1.375,0.756-1.719,0.825-2.407,1.03
		c-0.687,0.207-2.612,0.139-2.612,0.139l-1.788-0.963l-0.344-1.926v-1.032l1.031-0.274c0,0,1.375-1.649,1.169-1.72
		c-0.207-0.066-1.031-0.824-1.306-0.755C87.4,318.055,85.75,318.191,85.75,318.191z"/>
</g>
<g class="areabox itemhintfollow" title="金門縣">
	<path style="" d="M49.321,238.353c1.4,1.517,2.511,0.661,3.304,1.585c0.793,0.925,1.322,2.909,2.247,2.644
		c2.379,0.066,2.869-2.841,7.468-2.841c-0.264,1.85-0.132,1.917,0.33,1.917c0.463,0,0.728-0.396,1.388-0.528
		c0.661-0.133,2.313-0.992,2.048-1.52c-0.264-0.53-0.594-1.719,0.132-2.05c0.727-0.33,3.503-2.313,4.825-1.189
		c1.322,1.124,0.992,1.52,1.19,1.85c0.198,0.331,1.718,0.594,2.312-0.859c0.199-0.793-0.529-1.256-0.264-1.321
		c0.264-0.067,0.727-0.53,0.859-1.124c0.132-0.596-0.264-1.785,0.397-2.313c0.66-0.529,1.454-1.124,1.52-1.52
		c0.066-0.397-0.462-0.993,0.199-1.454c0.661-0.463,1.255-1.189,0.726-1.454c-0.528-0.265-1.123-0.331-1.652-0.793
		c-0.529-0.463-3.899-5.882-5.088-6.014c-1.19-0.132-1.388-0.463-1.587-0.529c-0.197-0.066-1.188,0.132-1.188,0.132
		s0.065,1.058-0.463,1.388c-0.529,0.331-1.454,0.131-2.049-0.198c-0.595-0.331-2.379-1.521-4.098-0.662
		c-1.718,0.859-1.917,2.775-2.247,4.428c-0.331,1.652-0.926,4.428-2.446,4.957c-1.52,0.53-3.371-0.065-3.965,0.265
		c-0.595,0.331-0.396,1.388-0.265,1.851c0.133,0.463,0.331,2.909,0.066,3.437c-0.264,0.529-0.33,0.529-0.727,0.529
		c-0.396,0-0.859,0-0.859,0s0,0.462-0.529,0.462C50.377,237.427,47.734,236.635,49.321,238.353z"/>
	<path style="" d="M80.03,244.389c0,0,0.44,1.498,0.528,1.851c0.088,0.352,1.587,1.233,1.763,1.938
		c0.176,0.704,1.321,0.615,1.674,1.85c0.353,1.234,0.264,1.41,1.058,2.202c0.792,0.793,0.97,1.411,0.97,1.94
		c0,0.529,1.057,0.969,1.057,0.969s2.115,0.528,2.732,1.322c0.617,0.792,1.322,2.114,1.762,2.467s1.145,0.529,1.585,1.058
		c0.442,0.528,1.234,1.057,1.499,1.321s1.41,1.234,1.41,1.234l1.057,0.441h1.674l0.265-0.353c0,0,1.499,0.087,1.939-0.177
		c0.44-0.265,0.882-0.793,2.467-2.996c1.586-2.203,4.671-7.402,7.226-8.547c2.556-1.145,5.022-4.935,10.839-4.935
		c2.378-0.618,3.965-0.618,3.965-0.618s3.833-0.087,4.185-0.087c0.353,0,0.924-0.396,1.277-0.221
		c0.353,0.177,2.027,0.353,2.336,0.397c0.308,0.045,2.158-0.044,2.292-0.044c0.131,0,0.792-0.265,0.792-0.132
		s0.485,1.233,0.748,1.233c0.265,0,2.998,1.103,3.481,1.719c0.486,0.618,1.014,1.234,1.102,1.543
		c0.088,0.307,0.926,0.748,0.926,0.924c0,0.176,0.66,1.278,0.66,1.278s1.456,0.176,2.601,0.793c1.146,0.616,3.392,1.629,3.392,1.629
		h0.793c0,0,0.132,0.397,0.132,0.926c0,0.53,0.441,1.499,1.059,2.468c0.616,0.969,0.705,2.819,0.263,2.997
		c-0.44,0.175-1.322,0.086-1.499,0.086c-0.176,0-1.938-0.131-2.025,0.046c-0.088,0.175,0.131,0.528,0.66,0.528
		c0.528,0,2.026,0.043,2.071,0.22c0.043,0.178,0.22,0.927-0.133,1.058c-0.352,0.132-1.453,0.528-1.938,0.397
		c-0.483-0.131-0.881-0.881-0.881-0.881s0.043,1.587,0.264,1.806c0.22,0.22,1.852-0.439,2.159-0.439
		c0.308,0,2.159,0.262,2.467,0.175c0.308-0.086,0.265-0.792,0.265-0.792s1.542,0.527,2.423,0.307
		c0.881-0.22,0.793-1.013,1.719-1.013c0.924,0,2.291-0.352,2.555-0.352c0.264,0,1.894-0.087,1.983-0.75
		c0.088-0.661-0.177-1.409,0.131-1.938c0.31-0.528,0.793-1.499,0.793-1.499s0.617-0.308,1.057-0.176
		c0.442,0.132,1.631,0.705,1.631,0.705s0.133-0.264,0.705-0.529c0.573-0.263,1.454-0.616,1.454-0.616s0.617-0.176,0.574-0.529
		c-0.044-0.352-0.75-0.397-0.75-0.528c0-0.134-0.175-1.103-0.087-1.234c0.087-0.132,0.483-0.705,0.131-1.103
		c-0.353-0.396-0.66-1.057-0.528-1.189c0.132-0.132,0.618-0.484,0.75-0.616c0.131-0.133,0.44-0.485,0.617-0.661
		c0.177-0.177,0.837-0.484,0.837-0.484s0.925-0.134,1.146,0.043c0.22,0.176,0.441,0.66,1.146,0.924
		c0.705,0.264,1.542-0.043,1.498-0.572c-0.043-0.529-0.44-0.968-0.353-1.366c0.088-0.396,0.132-1.014,0.353-1.276
		c0.221-0.266,0.969-0.927,0.969-1.543c0-0.617,0.177-0.925-0.088-1.058c-0.264-0.132-1.277-0.087-1.674-0.396
		c-0.396-0.308-0.749-1.146-0.968-2.688c-0.222-1.543-0.529-2.424-0.529-2.909c0-0.484,0.529-1.85,0.529-1.85
		s0.397-2.203,0.397-2.644s0-2.115,0.131-2.248c0.131-0.131,0.088-0.219,1.014-0.396s0.925-0.881,1.321-0.881
		s0.924-0.177,0.793-0.396c-0.132-0.221,0.308-0.881-0.309-1.058c-0.617-0.176-1.188-0.308-1.453-0.22
		c-0.265,0.087-0.176,0.484-1.102,0.484s-1.278-0.75-1.278-0.97c0-0.22-0.439-5.639-0.661-6.079
		c-0.221-0.441-0.484-0.573-0.44-0.837c0.044-0.265,0.396-0.705,0.089-1.057c-0.31-0.353-1.586-1.719-1.323-2.688
		c0.266-0.969,0.44-2.247,0.618-2.819c0.176-0.573,1.013-0.793,0.617-1.103c-0.397-0.308-0.925-0.572-1.409-0.836
		c-0.485-0.265-0.706-0.441-0.838-0.397c-0.132,0.044-0.264,0.177-0.705,0.221c-0.441,0.044-1.146,0.221-1.41-0.132
		c-0.266-0.353-0.883-0.705-1.191-0.705c-0.309,0-1.365-0.573-1.365-0.573s-0.749-0.925-0.969-1.585
		c-0.22-0.661,0-3.216-0.529-4.053c-0.53-0.837-0.838-2.248-0.662-2.379c0.178-0.133,0.838-0.264,0.795-0.396
		c-0.046-0.132-0.31-0.617-0.529-0.793c-0.22-0.176-0.794-0.352-1.146-0.661c-0.353-0.309-1.013-0.353-1.234-0.485
		c-0.22-0.132-1.101-0.308-1.233-0.308c-0.133,0-1.059,0.661-1.059,0.661l-0.22,0.617c0,0-1.145-0.132-1.365-0.441
		c-0.221-0.308-0.221-1.806-0.529-2.07c-0.309-0.264-0.485-0.881-0.75-0.573c-0.264,0.309-0.573,0.793-0.353,1.322
		c0.22,0.528,0.663,1.058,0.663,1.278s-0.529,0.837-0.31,1.233c0.221,0.397,0.706,1.058,0.706,1.19c0,0.132-0.573,1.102-0.662,1.277
		c-0.088,0.177,0.045,0.529-0.528,0.529c-0.573,0-1.674-0.309-2.07-0.044c-0.397,0.265-1.368,0.529-1.719,0.793
		c-0.352,0.265-0.617,0.396-0.836,0.396c-0.22,0-0.926,0.265-0.926,0.265s-0.397-0.088-1.014-0.22s-2.422-0.089-2.467,0.22
		c-0.044,0.308,0.441,1.058,0.441,1.234c0,0.176-0.662,1.938-0.662,2.247c0,0.309-0.397,1.41-0.397,1.542s-0.174,0.617-0.174,0.617
		s0,1.498,0,1.63c0,0.132,0.263,1.234,0,1.718c-0.265,0.485-0.265,0.661-0.53,0.793s-1.057,0.484-1.057,0.484
		s-0.529,0.221-0.837,0.221c-0.309,0-0.221-0.352-0.573,0c-0.353,0.352-0.53,0.528-0.53,0.528l-0.572,0.176l-0.485,0.75
		c0,0-0.131,0.749-0.661,0.661c-0.528-0.088-3.084-1.499-3.305-0.926s0.661,0.705,0.969,1.189c0.309,0.484,1.587,3.083,1.587,3.481
		c0,0.396-0.308,1.675-0.749,2.379c-0.44,0.705-1.718,1.895-1.939,1.982c-0.221,0.089-0.483,0.177-1.057-0.088
		c-0.572-0.264-0.704-0.749-1.323-0.396c-0.616,0.352-1.453,1.542-2.467,1.586c-1.012,0.044-2.864-0.264-4.096-1.102
		c-1.235-0.836-1.5-1.366-2.336-1.938c-0.837-0.573-2.159-0.396-2.688-0.528c-0.527-0.132-1.41-0.75-1.41-0.75
		s-4.317-4.053-5.903-6.036c-1.586-1.982-5.287-7.137-5.882-7.864c-0.594-0.727-1.256-1.057-1.85-1.586
		c-0.595-0.529-1.388-0.991-1.388-0.991s-0.066,0.595-0.661,0.859c-0.595,0.265-1.454-0.264-2.181,0.066
		c-0.727,0.331-2.181,1.256-2.644,1.652c-0.462,0.396-0.859,0.662-1.322,0.662s-1.057-0.067-1.454,0.065
		c-0.396,0.132-0.331,0.331-0.859,0.331c-0.529,0-1.124,0.264-1.785,0.925c-0.661,0.661-1.322,1.256-1.388,1.652
		c-0.066,0.396,0,0.595-0.529,0.793c-0.528,0.199,0,0.661,0.199,0.925c0.198,0.265,1.388,1.388,1.454,1.587
		c0.066,0.198,0.727,1.454,1.058,1.718c0.331,0.265,1.785,1.124,2.38,1.652c0.594,0.528,0.66,0.595,0.594,0.793
		c-0.065,0.198-0.792,0.859-0.792,1.189s0.33,3.437,0.396,4.164c0.066,0.728,0.727,2.644,0.66,3.306
		c-0.065,0.66-0.131,2.972-0.33,3.568c-0.199,0.596-0.397,1.52-0.397,2.115c0,0.594,0.066,1.652-0.198,1.652
		s-0.881-0.109-0.881-0.109s-0.088,0.573,0.177,0.573c0.264,0,3.04,0.308,3.127,0.66c0.088,0.353,0.441,0.882,0,0.882
		c-0.44,0-1.19-0.574-1.499-0.396c-0.308,0.176-1.233,0.572-1.365,0.572s-0.793-0.309-1.277-0.396
		c-0.485-0.087-1.587-0.087-1.807,0.087c-0.22,0.177-0.926,0.309-0.969,0.751c-0.044,0.44,0.132,1.718,0,1.981
		c-0.133,0.265-1.102,0.926-1.41,1.234c-0.309,0.308-1.19,0.926-1.983,1.058c-0.792,0.132-1.102-0.089-1.63-0.397
		c-0.529-0.308-0.485-1.058-1.278-1.321c-0.793-0.264-1.454-0.221-2.247-0.221s-1.63-0.396-1.938-0.396
		C80.559,243.772,79.722,243.552,80.03,244.389z"/>
</g>
<g class="areabox itemhintfollow" title="連江縣">
	<path style="" d="M59.271,138.063c-0.198,0.593-0.713,2.587-0.178,3.39c0.536,0.803,0.536,1.785,0.268,2.053
		c-0.268,0.267-0.446,1.07-0.179,1.07c0.268,0,1.785,0.446,2.052,1.159c0.268,0.714,0.357,1.695,0.893,1.427
		c0.535-0.268,1.427-1.338,1.427-1.338s0.535,0.803,0.892,0.269c0.358-0.535,0.803-1.249,0.803-1.249s1.874-0.893,3.211-1.785
		c1.339-0.893,2.499-1.428,2.499-2.409c0-0.981,0.088-1.606-0.803-1.695c-0.893-0.089-1.696,0.179-1.696-0.268
		c0-0.446,0.09-0.803-0.178-0.803s-1.606,0.536-1.874,0.714s-0.178,0.178-1.07,0.089c-0.893-0.089-0.268-0.089-1.428-0.089
		s-1.517,0-1.874-0.357c-0.357-0.356-1.517-0.624-1.517-0.624S59.449,137.527,59.271,138.063z"/>
	<path style="" d="M57.353,138.085c-0.468,0.401-1.138,1.271-1.138,2.008c0,0.735,0.134,1.538,0.736,1.405
		c0.603-0.135,1.138-0.135,0.938-1.07c-0.201-0.938,0.067-1.607-0.134-1.941C57.553,138.152,57.353,138.085,57.353,138.085z"/>
	<path style="" d="M75.753,137.35c0,0,0.937,1.137,1.673,1.27c0.736,0.134,1.54-0.066,1.473-0.401
		c-0.067-0.334,0-0.869-0.468-1.204c-0.469-0.334-1.138-0.602-1.74-0.602S75.753,137.35,75.753,137.35z"/>
	<path style="" d="M74.482,142.836c0,0-2.074,1.472-2.142,1.94c-0.066,0.469,0.469,0.736,1.205,0.669
		c0.736-0.067,1.338-0.87,1.539-1.272C75.285,143.773,75.418,142.569,74.482,142.836z"/>
	<path style="" d="M81.708,148.59c-0.468-0.401-0.602-0.536-1.205-0.536c-0.602,0-3.746-0.267-4.616,0.737
		c-0.87,1.004-0.669,2.141-1.405,2.476c-0.736,0.334-1.606,0.267-2.007,0.468c-0.402,0.201-0.535,0.134-0.669,0.602
		c-0.134,0.468,0,1.204-0.401,1.472c-0.401,0.268-2.007,1.138-2.208,1.807c-0.201,0.668,0.268,1.338,0.2,2.744
		c-0.067,1.405-2.275,3.145-1.94,3.68c0.335,0.535,1.74,0.401,2.676-0.067c0.937-0.468,1.673-1.54,2.007-2.744
		c0.335-1.204,1.071-2.141,1.071-2.141l1.004-0.535c0,0,2.476-0.335,3.211-0.468c0.736-0.133,1.004-0.133,1.272-0.535
		c0.268-0.401,0.401-1.338,0.401-1.338s0.669-0.536,0.87-0.602c0.201-0.067,1.606-0.469,1.941-0.736
		c0.334-0.268,1.74-1.539,2.677-2.208c0.936-0.669,2.609-1.137,1.806-2.141c-0.802-1.004-1.003-1.339-2.274-1.272
		C82.846,147.319,81.708,148.59,81.708,148.59z"/>
	<path style="" d="M78.229,147.052c0.522,0.139,2.945-1.071,2.542-1.74c-0.401-0.669-1.003-1.539-1.539-1.138
		C78.698,144.576,77.225,146.784,78.229,147.052z"/>
	<path style="" d="M83.849,127.514c-0.602,0.535-1.137,1.07-1.605,1.739c-0.468,0.669-1.405,2.007-2.008,2.609
		c-0.602,0.602-0.401,2.208,0.268,3.145c0.67,0.938,1.807,1.071,2.342,1.472c0.535,0.402,2.476,1.204,2.543,1.539
		c0.067,0.335,1.271,0.736,1.472,0.736c0.2,0,1.472,0,1.739-0.401c0.268-0.402,0.803-1.07,0.803-1.07s0.87-0.803,1.472-0.602
		c0.603,0.201,1.271,1.07,2.007,1.137c0.736,0.067,2.075-0.134,2.676-0.334c0.602-0.201,2.142-0.736,2.477-1.338
		c0.334-0.603,0.869-1.807,0.869-1.807s0.536,0.268,1.071,1.004c0.536,0.736,1.338,0.736,1.605,0.535
		c0.268-0.201,1.004-1.672,1.472-2.007s1.606-0.937,1.94-1.205c0.335-0.268,1.271-0.736,1.271-1.471
		c0-0.737,2.208-2.143,2.274-2.811c0.067-0.669-0.133-0.937-0.803-0.937c-0.668,0-1.337,0.803-2.074,0.335
		c-0.736-0.469-2.142-1.741-4.015-1.473c-1.874,0.268-4.751,0.67-5.286,1.473c-0.536,0.802-0.334,1.002-0.736,1.471
		c-0.401,0.469-1.472,1.539-2.409,1.473c-0.937-0.067-0.067-1.339,0-1.606c0.067-0.268,0-0.535-0.669-0.869
		c-0.668-0.335-0.735-1.205-0.735-1.205l-0.536-0.334c0,0-2.008,0-2.275-0.335c-0.268-0.335-0.268-0.603-0.268-0.603
		s0.2,0.134,0.87-0.869c0.669-1.004,0.401-0.804,0.937-1.406c0.536-0.602,0.803-0.802,0.803-0.802s0.669-0.736,0.201-1.338
		c-0.468-0.602-0.803-0.736-1.338-0.736c-0.536,0-0.937-0.736-0.937-0.937s-0.735-0.803-0.735-0.803s-2.142-1.07-2.677-0.401
		c-0.535,0.669-0.335,1.405-0.335,2.208c0,0.803-0.803,1.405-0.535,2.074c0.268,0.669,1.004,0.735,0.67,1.07
		c-0.335,0.335-2.142,1.071-2.543,1.539c-0.401,0.468-0.87,1.271-0.401,1.606C83.181,127.313,83.849,127.514,83.849,127.514z"/>
	<path style="" d="M112.264,128.293c-0.489-0.051-0.803-0.313-1.337,0.178c-0.537,0.492-1.472,1.741-1.561,2.365
		c-0.09,0.625-0.135,2.186,0.49,2.186c0.625,0,2.408-1.204,2.543-1.694C112.532,130.836,113.112,128.383,112.264,128.293z"/>
	<path style="" d="M114.183,125.039c0.447,0.355,0.847,0.891,0.759,1.427c-0.09,0.535-0.313,1.427-1.161,1.159
		c-0.848-0.268-0.714-0.937-0.581-1.516c0.135-0.58-0.089-1.07-0.089-1.07l-0.535,0.088c0,0-0.713,1.114-1.159,0.937
		c-0.447-0.178-1.25-0.268-1.027-1.115c0.224-0.848,0.803-1.561,0.893-2.052c0.09-0.49-0.133-2.32,0.178-2.811
		c0.313-0.49,1.74-3.791,2.097-4.148c0.357-0.356,0.848-0.268,0.669-0.759c-0.178-0.49-1.249-0.713-1.16-1.07
		c0.09-0.356,1.026-2.319,1.16-3.078s-0.044-1.606,0.225-1.606c0.267,0,1.337,0.714,1.471,0.892
		c0.135,0.179,0.223,0.223,0.535,0.179c0.313-0.045,1.294-1.428,1.518-1.473c0.223-0.044,0.223,0.491,1.161,0.224
		c0.937-0.268,0.579-0.045,0.937-0.268c0.355-0.223,0.712-0.401,0.936-0.401c0.222,0,0.713-1.115,0.713-1.249
		s0.269-0.669,0.446-0.625c0.179,0.044,1.517,0.714,2.008,0.625c0.491-0.09,1.383-0.313,1.383-0.313s1.025-0.446,1.292-0.446
		c0.268,0,1.071,0.089,1.338-0.045c0.268-0.133,0.848-1.159,1.338-1.338s1.382-0.357,1.561,0c0.179,0.357,0.446,0.446,0.937,0.446
		c0.492,0,2.097,1.874,2.633,2.498s1.427,0.536,1.115,0.937c-0.312,0.402-1.293,1.383-1.383,1.562
		c-0.089,0.178-0.223,1.159-0.535,1.204c-0.312,0.044-1.249,0.714-1.026,0.847c0.224,0.134,0.981,0.402,1.384,0.179
		c0.401-0.224,1.16-0.938,1.337-0.938c0.18,0,0.982-0.446,1.918,0c0.938,0.446,1.651,0.758,1.206,1.338
		c-0.447,0.58-0.937,0.624-0.982,0.981c-0.044,0.357-0.401,0.758-0.536,0.803c-0.133,0.045-0.712,0.536-1.115,0.759
		c-0.4,0.223-0.98,0.178-1.024,0.847c-0.045,0.669,0.043,1.338,0.757,2.052c0.714,0.713,1.606,0.892,1.249,1.427
		c-0.356,0.536-0.758,1.115-1.205,1.249c-0.445,0.134-0.936,0.536-0.758,0.937c0.179,0.402,0.313,0.803-0.446,0.803
		c-0.758,0-1.873-0.312-1.427-0.848c0.446-0.535,0.401-1.249,0.446-1.784c0.044-0.536,0.58-0.625,0.089-1.382
		c-0.491-0.758-0.848-0.938-0.803-1.339c0.043-0.402-0.09-0.848,0.043-1.249c0.135-0.402,0.269-0.669-0.043-0.848
		c-0.313-0.178-1.116-0.535-2.188-0.313c-1.07,0.224-0.981,1.026-1.694,1.026c-0.714,0-1.248,0.134-1.605-0.179
		c-0.357-0.312-0.714-0.534-0.981-0.491c-0.268,0.045-1.027,1.16-1.205,1.294c-0.178,0.134-0.892,0.714-1.204,0.313
		c-0.313-0.402-0.089-1.071-0.224-1.695c-0.133-0.625,0.224-0.491-0.133-0.625c-0.357-0.134-1.116,0.313-1.561,0.491
		c-0.446,0.178-1.383,0.669-1.918,0.535c-0.536-0.134-1.473-0.402-1.785-0.223c-0.312,0.178-0.625,0.223-0.714,0.713
		c-0.089,0.491,0.089,0.937-0.357,1.205c-0.446,0.268-1.516,0.223-1.605,0.892c-0.09,0.669-0.045,1.472-0.402,2.052
		c-0.357,0.58-0.58,0.847-0.758,1.115c-0.179,0.268-0.714,0.49-0.67,0.937c0.045,0.445,0.312,0.802,0.58,0.847
		s0.624,0.268,0.624,0.268s0.314,0.357,0.09,0.491c-0.223,0.134-0.803,0.447-0.803,0.447L114.183,125.039z"/>
	<path style="" d="M122.479,101.173c0.593-0.475,0.401-1.026,0.759-0.937c0.356,0.088,0.624,0.624,1.294,0.892
		c0.669,0.268,1.515,0.536,2.006,0.134c0.492-0.401,0.758-0.714,0.758-1.16c0-0.446-0.088-0.669,0.089-1.071
		c0.179-0.401,0.403-0.134,0.179-0.401c-0.223-0.268-0.49-0.625-0.356-0.758c0.133-0.134,0.535-0.713,0.624-0.847
		c0.09-0.134,0.313-0.269,0.179-0.669c-0.135-0.401-0.223-0.446-0.58-1.115c-0.357-0.669-0.535-1.204-0.803-1.071
		c-0.268,0.134-0.581,0.714-0.981,1.116c-0.402,0.401-0.802,0.802-0.936,0.892c-0.136,0.088-0.403,0.625-0.403,0.893
		c0,0.267,0.224,0.758,0.134,0.892c-0.089,0.134,0,0.847-0.713,0.981c-0.714,0.133-0.848,0.089-1.071,0.268
		c-0.223,0.179-0.668,0.356-0.759,0.624c-0.088,0.268-0.491,1.071-0.491,1.071S122.033,101.529,122.479,101.173z"/>
	<path style="" d="M133.364,104.34c0-0.356-0.357-1.382,0-1.785c0.356-0.401,1.606-1.115,1.606-1.115
		s1.516-0.357,1.873-0.447c0.357-0.088,1.695-0.446,1.695-0.312c0,0.133,0,0.535-0.089,1.204c-0.088,0.669,0.134,1.071-0.491,1.428
		c-0.625,0.356-0.714,0.356-1.561,0.356c-0.849,0-1.294-0.401-1.651-0.044c-0.356,0.357-0.937,0.892-1.159,0.802
		C133.364,104.34,133.364,104.34,133.364,104.34z"/>
	<path style="" d="M140.591,99.478c-0.212,0.07-0.403,0.803-0.67,0.981c-0.267,0.179-0.937,0.803-0.446,1.16
		c0.49,0.356,1.784,0.624,2.274,0.58c0.492-0.045,1.563-0.045,1.428-0.625c-0.134-0.58-0.223-0.535-0.401-0.758
		c-0.179-0.223-0.535-0.401-0.758-0.535C141.794,100.147,140.991,99.344,140.591,99.478z"/>
	<path style="" d="M139.876,103.358c-0.49,0.312-1.338,0.758-0.937,1.472c0.402,0.714,0.179,1.338,0.67,0.981
		c0.491-0.357,0.891-1.026,0.891-1.16s0.224-0.491,0.09-0.714C140.458,103.715,139.876,103.358,139.876,103.358z"/>
	<path style="" d="M142.196,104.786c0,0-0.134,0.714-0.491,0.937c-0.357,0.223-0.892,0.535-0.937,0.223
		c-0.045-0.312,0-0.981,0-0.981S141.883,104.25,142.196,104.786z"/>
	<path style="" d="M146.077,103.537c0.617,0.165,2.051,0.357,2.586,0.402c0.536,0.045,0.581,0.401,1.116,0.178
		s0.178-0.447,1.071-0.758c0.891-0.313,2.409,0,2.63-0.401c0.224-0.402,0.937-1.16,0.536-1.785
		c-0.402-0.625-0.268-1.294-1.206-1.427c-0.937-0.134-1.47-0.447-2.497,0.178c-1.026,0.624-1.606,0.624-2.231,0.981
		c-0.624,0.356-1.383,0.713-1.739,1.16C145.988,102.511,145.409,103.358,146.077,103.537z"/>
	<path style="" d="M159.637,89.842c-0.268,0-1.204-0.401-1.784,0.58c-0.579,0.981-0.759,2.275-1.205,2.32
		c-0.446,0.045-1.471,0.268-1.516-0.49c-0.045-0.758,0.402-2.23,0.758-2.722c0.357-0.491,0.803-0.847,1.25-1.16
		c0.445-0.312,0.49-0.535,0.847-0.981c0.357-0.446,0.536-1.65,1.16-1.784c0.624-0.134,1.472-0.089,1.784,0.446
		s0.982,0.625,1.205,0.625c0.224,0,1.16-0.089,0.981,0.535c-0.178,0.625-0.223,0.981,0.089,1.338
		c0.312,0.356,1.383,0.223,0.937,0.937c-0.445,0.713-0.491,1.293-0.625,1.694c-0.134,0.401-1.204,1.383-1.204,1.74
		c0,0.357,0.267,0.893,0.803,0.981c0.535,0.09,1.249,0,1.561,0.09c0.313,0.089,0.805,0.312,0.981,0.624
		c0.179,0.312,0.715,0.58,0.715,0.58s1.158-0.268,1.115-0.535c-0.046-0.268-0.18-1.472,0.4-1.828c0.58-0.357,1.07-0.536,1.562-0.447
		c0.489,0.089,1.783,0.045,1.873,0.447c0.089,0.401-0.223,0.668-0.223,1.426c0,0.759,0.179,1.071,0.669,1.473
		c0.491,0.401,0.981,0.848,1.427,0.848c0.445,0,1.606-0.536,1.606-0.536s0.357,0,0.267,0.58c-0.089,0.58,0.27,0.58,0.091,1.294
		c-0.18,0.713,0.179,0.847,0.312,0.847c0.134,0,0.891-0.356,1.115,0.09c0.223,0.446-0.27,1.472-0.403,1.874
		c-0.133,0.401-0.579,0.892-1.069,0.49c-0.491-0.401-0.849-0.669-0.982-0.713c-0.133-0.045-0.757-0.089-0.757-0.089
		s-0.312,0.133-0.58-0.178c-0.268-0.313-0.403-0.67-0.491-0.803c-0.09-0.134-0.358-0.491-1.026,0
		c-0.669,0.491-0.714,0.714-1.294,1.071c-0.581,0.356-0.982,0.312-0.982,0.669c0,0.356,0.045,0.58-0.133,0.625
		c-0.179,0.044-1.204,0-1.339,0.044c-0.133,0.045-0.67,0.402-0.846,0.669c-0.178,0.268-0.536,0.58-0.759,0.758
		c-0.223,0.179-0.492,0.357-0.713,0.58c-0.224,0.223-0.402,0.268-0.402,0.268s-0.446-0.312-0.938-0.714
		c-0.491-0.401-0.848-0.089-0.936-0.268c-0.089-0.178-0.134-0.357-0.313-0.758c-0.178-0.402-0.312-0.803-0.535-0.981
		c-0.223-0.179-0.223-0.313-0.446-0.179c-0.222,0.134-0.491,0.669-0.357,0.758c0.135,0.09,0.223,0.224,0.135,0.669
		c-0.09,0.446,0.133,0.714-0.313,0.803c-0.446,0.089-0.803,0.357-0.847,0.222c-0.045-0.133-0.491-0.668-0.536-0.936
		c-0.044-0.268-0.313-0.848-0.178-1.116c0.133-0.268-0.313-1.249,0.446-1.606c0.759-0.357,1.293-1.293,1.428-1.561
		c0.133-0.268,0.802-0.714,0.937-0.758c0.134-0.044,0.891-0.044,0.625-0.535c-0.269-0.491-0.848-0.937-0.848-0.937
		s-0.67,0.044-0.625-0.491c0.045-0.536,0.223-0.58,0.045-0.848c-0.178-0.268,0-0.847-0.402-0.446
		c-0.4,0.401-0.848,1.026-0.982,1.071c-0.133,0.044-0.757-0.402-0.98-1.071s-0.268-1.338-0.044-1.873
		c0.222-0.536,0.49-1.205,0.49-1.562C159.637,90.645,159.637,89.842,159.637,89.842z"/>
</g>
<path style="fill:none;stroke:#BDBDBD;" d="M184.518,170.479c0,1.275-1.035,2.31-2.309,2.31H42.62c-1.275,0-2.309-1.034-2.309-2.31
	V74.885c0-1.274,1.034-2.309,2.309-2.309h139.589c1.274,0,2.309,1.035,2.309,2.309V170.479z"/>
<path style="fill:none;stroke:#BDBDBD;" d="M184.518,280.061c0,1.274-1.035,2.309-2.309,2.309H42.62
	c-1.275,0-2.309-1.034-2.309-2.309v-95.594c0-1.275,1.034-2.31,2.309-2.31h139.589c1.274,0,2.309,1.034,2.309,2.31V280.061z"/>
<path style="fill:none;stroke:#BDBDBD;" d="M184.518,389.643c0,1.273-1.035,2.309-2.309,2.309H42.62
	c-1.275,0-2.309-1.035-2.309-2.309v-95.596c0-1.274,1.034-2.309,2.309-2.309h139.589c1.274,0,2.309,1.034,2.309,2.309V389.643z"/>
<g>
	<path style="fill:none;stroke:#FFFFFF;" d="M287.16,276.243c3.162-0.485,6.579-0.727,9.499,0.485
		c2.922,1.223,6.823,4.145,6.823,5.125c0,0.971-1.223,4.387-2.678,4.387c-1.465,0-3.173,0-3.173,0s-2.922,1.697-4.389,2.193
		c-1.455,0.485-1.938-2.932-3.891-4.145c-1.951-1.224-2.447-2.193-2.688-2.932C286.42,280.631,287.16,276.243,287.16,276.243z"/>
</g>
</svg>
    </div><!-- SVGcontent -->
</div><!-- obj-wrapperT1 -->
        <!-- taiwan map end -->

        <div class="twocol">
            <div class="right"><a href="#" class="genbtn closemagnificPopup">關閉</a></div>
        </div><!-- twocol -->
    </div><!-- padding10ALL -->

</div><!--magpopup -->

</asp:Content>