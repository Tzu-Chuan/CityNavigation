using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;

namespace ISTI_CityNavigation.handler
{
    public partial class GetGlobalDDL : System.Web.UI.Page
    {
        KeyTable_DB k_db = new KeyTable_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 查詢代碼檔
            ///說明:
            /// * Request["group"]: KeyTable Group 代碼(K_Code)
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string group = (string.IsNullOrEmpty(Request["group"])) ? "" : Request["group"].ToString().Trim();
                k_db._K_Code = group;
                DataTable dt = k_db.GetGlobal_DDL();

                string xmlstr = string.Empty;
                xmlstr = DataTableToXml.ConvertDatatableToXML(dt, "dataList", "data_item");
                xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + "</root>";
                xDoc.LoadXml(xmlstr);
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