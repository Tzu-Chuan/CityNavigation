using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class GetDDL : System.Web.UI.Page
    {
        CodeTable_DB ct_db = new CodeTable_DB();
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 查詢代碼檔
            ///說    明:
            /// * Request["group"]: CodeTable Group 代碼
            /// * Request["item"]: CodeTable Item 代碼
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string group = (string.IsNullOrEmpty(Request["group"])) ? "" : Request["group"].ToString().Trim();
                string item = (string.IsNullOrEmpty(Request["item"])) ? "" : Request["item"].ToString().Trim();
                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                if (Common.VeriftyToken(token))
                {
                    ct_db._C_Item = item;
                    DataTable dt = ct_db.getCommonCode(group);

                    string xmlstr = string.Empty;
                    xmlstr = DataTableToXml.ConvertDatatableToXmlByAttribute(dt, "dataList", "data_item");
                    xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + "</root>";
                    xDoc.LoadXml(xmlstr);
                }
                else
                {
                    xDoc = ExceptionUtil.GetErrorMassageDocument("TokenFail");
                }
            }
            catch (Exception ex)
            {
                xDoc = ExceptionUtil.GetExceptionDocument(ex);
            }
            Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
            xDoc.Save(Response.Output);
        }
    }
}