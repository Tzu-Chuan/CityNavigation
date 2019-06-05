<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/BackEnd.Master" AutoEventWireup="true" CodeBehind="PageImport.aspx.cs" Inherits="ISTI_CityNavigation.Manage.PageImport" %>

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
                    var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none" />');
                    var form = $("form")[0];
                    var strType = document.createElement('input');

                    strType.setAttribute("id", "selType");
                    strType.setAttribute("name", "selType");
                    strType.setAttribute("value", $("#selType").val());
                    strType.setAttribute("style", "display: none");

                    form.appendChild(iframe[0]);
                    form.appendChild(strType);

                    form.setAttribute("action", "mHandler/ImportPopulation.aspx");
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
            alert(msg);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="OchiFixTable width100 TitleLength05"">
            <div class="OchiRow">
                <div class="OchiCell OchiTitle TitleSetWidth">
                    檔案類別
                </div>
                <div class="OchiCell width100">
                    <select id="selType" name="selClass" class="inputex">
                        <option value="01">土地人口</option>
                    </select>
                </div>
            </div>
            <div class="OchiRow">
                <div class="OchiCell OchiTitle TitleSetWidth">
                    選擇檔案
                </div>
                <div class="OchiCell width100">
                    <input type="file" id="importFile" name="importFile" class="inputex" />
                </div>
            </div>
            <div class="OchiRow" style="text-align:right;">
                <input type="button" id="btnUpload" class="genbtn" value="上傳" />
            </div>
        </div> 
    </div>
    
</asp:Content>
