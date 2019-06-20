<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="CityInfoTable.aspx.cs" Inherits="ISTI_CityNavigation.WebPage.CityInfoTable" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        //取city參數
        var CityNo = $.getParamValue("city");
        //取table參數
        var ListClass = $.getParamValue("listame");
        //table標籤class初始化
        var oSpanClass = "Population_Class";

        $(document).ready(function () {
            if (CityNo != "" && ListClass == "") {
                getCityName();
                PopulationTable();
            }

            if (CityNo != "" && ListClass != "") {
                switch (ListClass) {
                case "Population"://人口土地
                    getCityName();
                    PopulationTable();
                    break;
                case "Travel"://觀光
                    getCityName();
                    TraveldTable();
                    break;
                case "Traffic"://交通
                    getCityName();
                    TrafficTable();
                    break;
                case "Farming"://農業
                    getCityName();
                    FarmingTable();
                    break;
                case "Industry"://產業
                    getCityName();
                    IndustryTable();
                    break;
                case "Retail"://零售
                    getCityName();
                    RetailTable();
                    break;
                case "Safety"://智慧安全、治理
                    getCityName();
                    SafetyTable();
                    break;
                case "Energy"://能源
                    getCityName();
                    EnergyTable();
                    break;
                case "Health"://健康
                    getCityName();
                    HealthTable();
                    break;
                case "Education"://教育
                    getCityName();
                    EducationTable();
                        break;
                case "Mayor"://教育
                    getCityName();
                    MayorTable();
                    break;
                }
            }


            //人口table
            $(document).on("click","#Population", function () {
                PopulationTable();
            })

            //土地table
            $(document).on("click", "#Land", function () {
                LandTable();
            })

            //動態產生觀光table
            $(document).on("click", "#Travel", function () {
                TraveldTable();
            })

            //動態產生交通table
            $(document).on("click", "#Traffic", function () {
                TrafficTable();
            })

            //動態產生農業table
            $(document).on("click", "#Farming", function () {
                FarmingTable();
            })

            //動態產生產業table
            $(document).on("click", "#Industry", function () {
                IndustryTable();
            })

            //動態產生零售table
            $(document).on("click", "#Retail", function () {
                RetailTable();
            })

            //動態產生智慧安全、治理table
            $(document).on("click", "#Safety", function () {
                SafetyTable();
            })

            //動態產生能源table
            $(document).on("click", "#Energy", function () {
                EnergyTable();
            })

            //動態產生健康table
            $(document).on("click", "#Health", function () {
                HealthTable();
            })

            //動態產生教育table
            $(document).on("click", "#Education", function () {
                EducationTable();
            })

            //動態產生市長/副市長table
            $(document).on("click", "#Mayor", function () {
                MayorTable();
            })
        })// js end

        
        function getCityName() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetCityName.aspx",
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
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                $("#CityName").html($(this).children("C_Item_cn").text().trim());
                            });
                        }
                    }
                }
            });
        }

        //人口土地table
        function PopulationTable() {
            $("#Wrapper").empty();
            document.getElementById(oSpanClass).className = "SlimTabBtnV2";
            document.getElementById("Population_Class").className = "SlimTabBtnV2 SlimTabBtnV2Current";
            oSpanClass = "Population_Class";

            var x = 0;//限制table增加數量
            var wrapper = $("#Wrapper");
            if (x == 0) {
                $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Population_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                getPopulationList();
                x++;
            }
        }

        //撈人口土地列表
        function getPopulationList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetPopulationList.aspx",
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
                        var tabstr7 = '';

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

                                tabstr7 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr7 += '<td align="center" nowrap="nowrap">土地面積</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("P_AreaYear").text().trim() + '年' + '</td>';
                                tabstr7 += '<td align="center" nowrap="nowrap">' + $(this).children("P_Area").text().trim() + 'km<sup>2</sup>' + '</td>';
                                tabstr7 += '</td></tr>';

                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Population_list tbody").append(tabstr + tabstr1 + tabstr2 + tabstr3 + tabstr4 + tabstr5 + tabstr6 + tabstr7);
                        //$("#Population_list tbody").append(tabstr1);
                    }
                }
            });
        }

        //觀光table
        function TraveldTable() {
            $("#Wrapper").empty();
            document.getElementById(oSpanClass).className = "SlimTabBtnV2";
            document.getElementById("Travel_Class").className = "SlimTabBtnV2 SlimTabBtnV2Current";
            oSpanClass = "Travel_Class";

            var x = 0;//限制table增加數量
            var wrapper = $("#Wrapper");
            if (x == 0) {
                $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Travel_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                getTravelList();
                x++;
            }
        }

        //撈觀光列表
        function getTravelList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTravelList.aspx",
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

        //交通table
        function TrafficTable() {
            $("#Wrapper").empty();
                document.getElementById(oSpanClass).className = "SlimTabBtnV2";
                document.getElementById("Traffic_Class").className = "SlimTabBtnV2 SlimTabBtnV2Current";
                oSpanClass = "Traffic_Class";

                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Traffic_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getTrafficList();
                    x++;
                }
        }

        //撈交通列表
        function getTrafficList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetTrafficList.aspx",
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

        //農業table
        function FarmingTable() {
            $("#Wrapper").empty();
                document.getElementById(oSpanClass).className = "SlimTabBtnV2";
                document.getElementById("Farming_Class").className = "SlimTabBtnV2 SlimTabBtnV2Current";
                oSpanClass = "Farming_Class";

                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Farming_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getFarmingList();
                    x++;
                }
        }

        //撈農業列表
        function getFarmingList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetFarmingList.aspx",
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

        //產業table
        function IndustryTable() {
            $("#Wrapper").empty();
                document.getElementById(oSpanClass).className = "SlimTabBtnV2";
                document.getElementById("Industry_Class").className = "SlimTabBtnV2 SlimTabBtnV2Current";
                oSpanClass = "Industry_Class";

                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Industry_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getIndustryList();
                    x++;
                }
        }

        //撈產業列表
        function getIndustryList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetIndustryList.aspx",
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

        //零售table
        function RetailTable() {
            $("#Wrapper").empty();
                document.getElementById(oSpanClass).className = "SlimTabBtnV2";
                document.getElementById("Retail_Class").className = "SlimTabBtnV2 SlimTabBtnV2Current";
                oSpanClass = "Retail_Class";

                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Retail_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getRetailList();
                    x++;
                }
        }

        //撈零售列表
        function getRetailList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetRetailList.aspx",
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

        //撈智慧安全、治理Table
        function SafetyTable() {
            $("#Wrapper").empty();
                document.getElementById(oSpanClass).className = "SlimTabBtnV2";
                document.getElementById("Safety_Class").className = "SlimTabBtnV2 SlimTabBtnV2Current";
                oSpanClass = "Safety_Class";

                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Safety_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getSafetyList();
                    x++;
                }
        }

        //撈智慧安全、治理列表
        function getSafetyList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetSafetyList.aspx",
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

        //能源table
        function EnergyTable() {
            $("#Wrapper").empty();
                document.getElementById(oSpanClass).className = "SlimTabBtnV2";
                document.getElementById("Energy_Class").className = "SlimTabBtnV2 SlimTabBtnV2Current";
                oSpanClass = "Energy_Class";

                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Energy_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getEnergyList();
                    x++;
                }
        }

        //撈能源列表
        function getEnergyList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEnergyList.aspx",
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

        //健康table
        function HealthTable() {
            $("#Wrapper").empty();
                document.getElementById(oSpanClass).className = "SlimTabBtnV2";
                document.getElementById("Health_Class").className = "SlimTabBtnV2 SlimTabBtnV2Current";
                oSpanClass = "Health_Class";

                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Health_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getHealthList();
                    x++;
                }
        }

        //撈健康列表
        function getHealthList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetHealthList.aspx",
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

        //教育table
        function EducationTable() {
            $("#Wrapper").empty();
                document.getElementById(oSpanClass).className = "SlimTabBtnV2";
                document.getElementById("Education_Class").className = "SlimTabBtnV2 SlimTabBtnV2Current";
                oSpanClass = "Education_Class";

                var x = 0;//限制table增加數量
                var wrapper = $("#Wrapper");
                if (x == 0) {
                    $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Education_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                    getEducationList();
                    x++;
                }
        }

        //撈教育列表
        function getEducationList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetEducationList.aspx",
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

        //市市長/副市長table
        function MayorTable() {
            $("#Wrapper").empty();
            document.getElementById(oSpanClass).className = "SlimTabBtnV2";
            document.getElementById("Mayor_Class").className = "SlimTabBtnV2 SlimTabBtnV2Current";
            oSpanClass = "Mayor_Class";

            var x = 0;//限制table增加數量
            var wrapper = $("#Wrapper");
            if (x == 0) {
                $(wrapper).append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="Mayor_list"><thead><tr><th>項目</th><th>資料年度</th><th>統計數據</th></tr></thead><tbody></tbody></table>');
                getMayorList();
                x++;
            }
        }
        
        //撈市市長/副市長列表
        function getMayorList() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "../handler/GetMayorList.aspx",
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
                         $("#Mayor_list tbody").empty();
                        var tabstr = '';
                        var tabstr1 = '';
                        var tabstr2 = '';
                        var tabstr3 = '';

                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                tabstr += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr += '<td align="center" nowrap="nowrap">直轄市/縣市長</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("MR_MayorYear").text().trim() + '年' + '</td>';
                                tabstr += '<td align="center" nowrap="nowrap">' + $(this).children("MR_Mayor").text().trim() + '</td>';
                                tabstr += '</td></tr>';

                                tabstr1 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr1 += '<td align="center" nowrap="nowrap">副縣/市長</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("MR_ViceMayorYear").text().trim() + '年' + '</td>';
                                tabstr1 += '<td align="center" nowrap="nowrap">' + $(this).children("MR_ViceMayor").text().trim() + '</td>';
                                tabstr1 += '</td></tr>';

                                tabstr2 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr2 += '<td align="center" nowrap="nowrap">推薦政黨</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("MR_PoliticalPartyYear").text().trim() + '年' + '</td>';
                                tabstr2 += '<td align="center" nowrap="nowrap">' + $(this).children("MR_PoliticalParty").text().trim() +'</td>';
                                tabstr2 += '</td></tr>';

                                tabstr3 += (i % 2 == 1) ? '<tr>' : '<tr class="alt">';
                                tabstr3 += '<td align="center" nowrap="nowrap">行政區數</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("MR_AdAreaYear").text().trim() + '年' + '</td>';
                                tabstr3 += '<td align="center" nowrap="nowrap">' + $(this).children("MR_AdArea").text().trim() + '</td>';
                                tabstr3 += '</td></tr>';
                            });
                        }
                        else
                            tabstr += '<tr><td colspan="6">查詢無資料</td></tr>';
                        $("#Mayor_list tbody").append(tabstr + tabstr1 + tabstr3);
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
                <div class="left"><span class="font-size4" id="CityName"></span></div>
                <!-- left -->
                <div class="right"><%--首頁 / 桃園市 / 桃園市人口--%></div>
                <!-- right -->
            </div>
            <!-- twocol -->
            <div class="tabmenublockV2wrapper margin10T">
                <div class="tabmenublockV2">
                    <span class="SlimTabBtnV2 SlimTabBtnV2Current" id="Population_Class"><a id="Population" href="javascript:void(0)" target="_self">人口土地</a></span>
                    <span class="SlimTabBtnV2" id="Travel_Class"><a id="Travel" href="javascript:void(0)" target="_self">觀光</a></span>
                    <span class="SlimTabBtnV2" id="Traffic_Class"><a id="Traffic" href="javascript:void(0)" target="_self">交通</a></span>
                    <span class="SlimTabBtnV2" id="Farming_Class"><a id="Farming" href="javascript:void(0)" target="_self">農業</a></span>
                    <span class="SlimTabBtnV2" id="Mayor_Class"><a id="Mayor" href="javascript:void(0)" target="_self">市長/副市長</a></span>
                    <span class="SlimTabBtnV2" id="Industry_Class"><a id="Industry" href="javascript:void(0)" target="_self">產業</a></span>
                    <span class="SlimTabBtnV2" id="Retail_Class"><a id="Retail" href="javascript:void(0)" target="_self">零售</a></span>
                    <span class="SlimTabBtnV2" id="Safety_Class"><a id="Safety" href="javascript:void(0)" target="_self">智慧安全、治理</a></span>
                    <span class="SlimTabBtnV2" id="Energy_Class"><a id="Energy" href="javascript:void(0)" target="_self">能源</a></span>
                    <span class="SlimTabBtnV2" id="Health_Class"><a id="Health" href="javascript:void(0)" target="_self">健康</a></span>
                    <span class="SlimTabBtnV2" id="Education_Class"><a id="Education" href="javascript:void(0)" target="_self">教育</a></span>
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
    <!--magpopup -->
</asp:Content>
