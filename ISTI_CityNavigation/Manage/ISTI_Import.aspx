<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/BackEnd.Master" AutoEventWireup="true" CodeBehind="ISTI_Import.aspx.cs" Inherits="ISTI_CityNavigation.Manage.ISTI_Import" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        //上傳按鈕
        $(document).ready(function () {
            $("#btnUpload").click(function () {
                try {
                    if ($("#importFile").val() == "") {
                        alert("請選擇要匯入的檔案");
                        return;
                    }
                    var exten = $("#importFile").val().replace(/^.*\./, '');
                    var PassExten = ["xls", "xlsx"];
                    if ($.inArray(exten, PassExten) == -1) {
                        alert("請上傳Excel檔");
                        return;
                    }

                    //根據下拉選單選項各自倒到各自的匯入程式
                    var strpost = "";
                    switch ($("#selType").val()) {
                        case "01"://土地人口
                            strpost = "mHandler/ImportPopulation.aspx";
                            break;
                        case "02"://觀光
                            strpost = "mHandler/ImportTravel.aspx";
                            break;       
                        case "03"://交通     
                            strpost = "mHandler/ImportTraffic.aspx";
                            break;
                        case "04"://農業
                            strpost = "mHandler/ImportFarming.aspx";
                            break;
                        case "05"://市長副市長
                            strpost = "mHandler/ImportMayor.aspx";
                            break;
                        case "06"://產業
                            strpost = "mHandler/ImportIndustry.aspx";
                            break;       
                        case "07"://零售     
                            strpost = "mHandler/ImportRetail.aspx";
                            break;       
                        case "08"://安全     
                            strpost = "mHandler/ImportSafety.aspx";
                            break;
                        case "09"://能源
                            strpost = "mHandler/ImportEnergy.aspx";
                            break;
                        case "10"://健康
                            strpost = "mHandler/ImportHealth.aspx";
                            break;
                        case "11"://教育
                            strpost = "mHandler/ImportEducation.aspx";
                            break;

                    }

                    var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none" />');
                    var form = $("form")[0];
                    var strType = document.createElement('input');
                    
                    strType.setAttribute("id", "selType");
                    strType.setAttribute("name", "selType");
                    strType.setAttribute("value", $("#selType").val());
                    strType.setAttribute("style", "display: none");

                    form.appendChild(iframe[0]);
                    form.appendChild(strType);

                    form.setAttribute("action", "" + strpost + "");
                    form.setAttribute("method", "post");
                    form.setAttribute("enctype", "multipart/form-data");
                    form.setAttribute("encoding", "multipart/form-data");
                    form.setAttribute("target", "postiframe");
                    form.submit();
                }
                catch (ex) {
                    alert(ex);
                }
            });
        });

        function feedbackFun(msg) {
            $("#Msg").html(msg);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="twocol titleLineA">
        <div class="left"><span class="font-size4">ISTI 資料管理</span></div><!-- left -->
        <div class="right">後臺管理 / ISTI 資料管理</div><!-- right -->
    </div><!-- twocol -->

    <div class="margin10T">
        Excel 上傳範例檔下載：<a href="<%=ResolveUrl("~/Sample/ISTI匯入資料範例.zip") %>">ISTI匯入資料範例.zip</a>
    </div>
    <div style="margin-top:10px;">
        檔案類別：
        <select id="selType" name="selClass" class="inputex">
            <option value="01">土地人口</option>
            <option value="02">觀光</option>
            <option value="03">交通</option>
            <option value="04">農業</option>
            <option value="05">市長副市長</option>
            <option value="06">產業</option>
            <option value="07">零售</option>
            <option value="08">安全</option>
            <option value="09">能源</option>
            <option value="10">健康</option>
            <option value="11">教育</option>
        </select>
    </div>
    <div style="margin-top:10px;">
        選擇檔案：<input type="file" id="importFile" name="importFile" class="inputex" />&nbsp;<input type="button" id="btnUpload" class="genbtn" value="上傳" />
        <input type="hidden" id="mToken" name="mToken" runat="server" ClientIDMode='Static' value="">
    </div>
    <div id="Msg" class="margin10T" style="color:red;"></div>
</asp:Content>
