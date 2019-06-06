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
    public partial class GetMemberInfo : System.Web.UI.Page
    {
        Member_DB m_db = new Member_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 查詢會員資訊
            ///說    明:
            /// * Request["id"]: 會員ID
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string id = (Request["id"] != null) ? Request["id"].ToString().Trim() : "";

                string xmlstr = string.Empty;

                m_db._M_ID = id;
                DataTable dt = m_db.getMemberById();

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