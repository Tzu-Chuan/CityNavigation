using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Data;

namespace ISTI_CityNavigation.handler
{
    public partial class GetCSE : System.Web.UI.Page
    {
        KeyTable_DB k_db = new KeyTable_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: Custom Search Engine
            ///說    明:
            ///-----------------------------------------------------
            DataTable dt = new DataTable();
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string City = (string.IsNullOrEmpty(Request["City"])) ? "" : Request["City"].ToString().Trim();
                string Type = (string.IsNullOrEmpty(Request["Type"])) ? "" : Request["Type"].ToString().Trim();
                string Keyword = (string.IsNullOrEmpty(Request["Keyword"])) ? "" : Request["Keyword"].ToString().Trim();
                string xmlstr = string.Empty;

                k_db._KeyWord = Keyword;
                k_db._K_Code = Type;
                dt = k_db.GetGlobalList();
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