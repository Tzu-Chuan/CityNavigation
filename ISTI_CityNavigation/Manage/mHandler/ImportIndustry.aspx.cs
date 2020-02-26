using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NPOI.SS.UserModel;//-- v.1.2.4起 新增的。
using NPOI.XSSF.UserModel;//-- XSSF 用來產生Excel 2007檔案（.xlsx）
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class ImportIndustry : System.Web.UI.Page
    {
        Industry_DB IY_DB = new Industry_DB();
        ImportData_Log idl_db = new ImportData_Log();
        //建立共用參數
        string strErrorMsg = "";
        int strMaxVersion = 0;
        DateTime dtNow = DateTime.Now;
        protected void Page_Load(object sender, EventArgs e)
        {
            //讀取Token值
            string token = (string.IsNullOrEmpty(Request["InfoToken"])) ? "" : Request["InfoToken"].ToString().Trim();
            if (VeriftyToken(token))
            {
                //建立共用connection & transaction
                SqlConnection oConn = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"].ToString());
                oConn.Open();
                SqlCommand oCmd = new SqlCommand();
                oCmd.Connection = oConn;
                SqlTransaction myTrans = oConn.BeginTransaction();
                oCmd.Transaction = myTrans;

                //建立DataTable Bulk Copy用
                DataTable dt = new DataTable();
                dt.Columns.Add("Ind_CityNo", typeof(string)).MaxLength = 2;
                dt.Columns.Add("Ind_CityName", typeof(string)).MaxLength = 10;
                dt.Columns.Add("Ind_BusinessYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Ind_Business", typeof(string)).MaxLength = 500;
                dt.Columns.Add("Ind_FactoryYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Ind_Factory", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Ind_IncomeYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Ind_Income", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Ind_SalesYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Ind_Sales", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Ind_CreateDate", typeof(string));
                dt.Columns.Add("Ind_CreateID", typeof(string));
                dt.Columns.Add("Ind_CreateName", typeof(string));
                dt.Columns.Add("Ind_Status", typeof(string));
                dt.Columns.Add("Ind_Version", typeof(string));

                try
                {
                    HttpFileCollection uploadFiles = Request.Files;//檔案集合
                    HttpPostedFile aFile = uploadFiles[0];
                    //判斷有沒有檔案
                    if (uploadFiles.Count < 1 || aFile.FileName == "")
                    {
                        throw new Exception("請選擇檔案");
                    }

                    //有檔案繼續往下做
                    if (uploadFiles.Count > 0)
                    {
                        string extension = (System.IO.Path.GetExtension(aFile.FileName) == "") ? "" : System.IO.Path.GetExtension(aFile.FileName);
                        if (extension != ".xls" && extension != ".xlsx")
                        {
                            throw new Exception("請選擇xls或xlsx檔案上傳");
                        }

                        IWorkbook workbook;// = new HSSFWorkbook();//创建Workbook对象
                        workbook = new XSSFWorkbook(aFile.InputStream);

                        ISheet sheet = workbook.GetSheetAt(0);//當前sheet

                        //簡易判斷這份Excel是不是產業的Excel
                        int cellsCount = sheet.GetRow(0).Cells.Count;
                        //1.判斷表頭欄位數
                        if (cellsCount != 5)
                        {
                            throw new Exception("請檢查是否為產業的匯入檔案");
                        }
                        //2.檢查欄位名稱
                        if (sheet.GetRow(0).GetCell(1).ToString().Trim() != "形成群聚之產業(依工研院產科國際所群聚資料)" || sheet.GetRow(0).GetCell(2).ToString().Trim() != "營運中工廠家數")
                        {
                            throw new Exception("請檢查是否為產業的匯入檔案");
                        }

                        //取得當前最大版次 (+1變成現在版次)
                        strMaxVersion = IY_DB.getMaxVersin() + 1;

                        //取得代碼檔
                        CodeTable_DB code_db = new CodeTable_DB();
                        DataTable dtCode = code_db.getCommonCode("02");

                        string cityNo = string.Empty;

                        //資料從第四筆開始 最後一筆是合計不進資料庫
                        for (int j = 3; j < sheet.PhysicalNumberOfRows - 1; j++)
                        {
                            if (sheet.GetRow(j).GetCell(0).ToString().Trim() != "" && sheet.GetRow(j).GetCell(0).ToString().Trim() != "全台平均")
                            {
                                DataRow row = dt.NewRow();
                                cityNo = Common.GetCityCodeItem(dtCode, sheet.GetRow(j).GetCell(0).ToString().Trim());//縣市代碼
                                if (cityNo == "")
                                {
                                    throw new Exception("第" + (j + 1) + "筆資料：" + sheet.GetRow(j).GetCell(0).ToString().Trim() + "不是一個正確的縣市名稱");
                                }

                                strErrorMsg = "行數:第" + (j + 1).ToString() + " 筆<br>";
                                row["Ind_CityNo"] = cityNo;//縣市代碼
                                row["Ind_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                                row["Ind_BusinessYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//形成群聚之產業(依工研院產科國際所群聚資料)-資料年度(民國年)
                                row["Ind_Business"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//形成群聚之產業(依工研院產科國際所群聚資料)
                                row["Ind_FactoryYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年", "");//營運中工廠家數-資料年度(民國年)
                                row["Ind_Factory"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//營運中工廠家數-家
                                row["Ind_IncomeYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//工廠營業收入-資料年度(民國年)
                                row["Ind_Income"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//工廠營業收入-千元
                                row["Ind_SalesYear"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//營利事業銷售額-資料年度(民國年)
                                row["Ind_Sales"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//營利事業銷售額-千元
                                row["Ind_CreateDate"] = dtNow;
                                row["Ind_CreateID"] = LogInfo.mGuid;//建立者GUID
                                row["Ind_CreateName"] = LogInfo.name;//建立者姓名
                                row["Ind_Status"] = "A";
                                row["Ind_Version"] = strMaxVersion;

                                dt.Rows.Add(row);
                            }

                        }

                        if (dt.Rows.Count > 0)
                        {
                            strErrorMsg = "";
                            BeforeBulkCopy(oConn, myTrans);//檢查資料表裡面是不是有該年的資料
                            DoBulkCopy(myTrans, dt, strErrorMsg);//匯入
                            myTrans.Commit();//最後再commit
                        }
                    }

                }
                catch (Exception ex)
                {
                    strErrorMsg += "錯誤訊息:" + ex.Message + "<br>";
                    strErrorMsg += "(欄位名稱請參考上傳範例檔)";
                    myTrans.Rollback();
                }
                finally
                {
                    oCmd.Connection.Close();
                    oConn.Close();

                    if (strErrorMsg == "")
                    {
                        /// Log
                        idl_db._IDL_Type = "ISTI";
                        idl_db._IDL_IP = Common.GetIPv4Address();
                        idl_db._IDL_Description = "檔案類別:產業 , 狀態：上傳成功";
                        idl_db._IDL_ModId = LogInfo.mGuid;
                        idl_db._IDL_ModName = LogInfo.name;
                        idl_db.addLog();
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('產業匯入成功');</script>");
                    }
                    else
                    {
                        /// Log
                        idl_db._IDL_Type = "ISTI";
                        idl_db._IDL_IP = Common.GetIPv4Address();
                        idl_db._IDL_Description = "檔案類別:產業 , 狀態：上傳失敗";
                        idl_db._IDL_ModId = LogInfo.mGuid;
                        idl_db._IDL_ModName = LogInfo.name;
                        idl_db.addLog();
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
                    }
                }
            }
            else
            {
                strErrorMsg = "連線失敗請重新登入";
                Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
            }    
        }

        //insert 前判斷是不是同年份有資料了
        private void BeforeBulkCopy(SqlConnection oConn, SqlTransaction oTran)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"
                declare @chkRowCount int = 0;
                select @chkRowCount = count(*) from Industry where Ind_Status='A'

                if @chkRowCount>0
                    begin
                        update Industry set Ind_Status='D' where Ind_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //產業 BulkCopy
        private void DoBulkCopy(SqlTransaction oTran, DataTable srcData, string errorMsg)
        {
            SqlBulkCopyOptions setting = SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.TableLock;
            using (SqlBulkCopy sqlBC = new SqlBulkCopy(oTran.Connection, setting, oTran))
            {
                sqlBC.BulkCopyTimeout = 600; ///設定逾時的秒數
                //sqlBC.BatchSize = 1000; ///設定一個批次量寫入多少筆資料, 設定值太小會影響效能 
                ////設定 NotifyAfter 屬性，以便在每複製 10000 個資料列至資料表後，呼叫事件處理常式。
                //sqlBC.NotifyAfter = 10000;
                ///設定要寫入的資料庫
                sqlBC.DestinationTableName = "Industry";

                /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
                sqlBC.ColumnMappings.Add("Ind_CityNo", "Ind_CityNo");
                sqlBC.ColumnMappings.Add("Ind_CityName", "Ind_CityName");
                sqlBC.ColumnMappings.Add("Ind_BusinessYear", "Ind_BusinessYear");
                sqlBC.ColumnMappings.Add("Ind_Business", "Ind_Business");
                sqlBC.ColumnMappings.Add("Ind_FactoryYear", "Ind_FactoryYear");
                sqlBC.ColumnMappings.Add("Ind_Factory", "Ind_Factory");
                sqlBC.ColumnMappings.Add("Ind_IncomeYear", "Ind_IncomeYear");
                sqlBC.ColumnMappings.Add("Ind_Income", "Ind_Income");
                sqlBC.ColumnMappings.Add("Ind_SalesYear", "Ind_SalesYear");
                sqlBC.ColumnMappings.Add("Ind_Sales", "Ind_Sales");
                sqlBC.ColumnMappings.Add("Ind_CreateDate", "Ind_CreateDate");
                sqlBC.ColumnMappings.Add("Ind_CreateID", "Ind_CreateID");
                sqlBC.ColumnMappings.Add("Ind_CreateName", "Ind_CreateName");
                sqlBC.ColumnMappings.Add("Ind_Status", "Ind_Status");
                sqlBC.ColumnMappings.Add("Ind_Version", "Ind_Version");

                /// 開始寫入資料
                sqlBC.WriteToServer(srcData);
            }
        }

        //判斷Token是否正確
        private bool VeriftyToken(string clientToken)
        {
            if (string.IsNullOrEmpty(clientToken)) return false;

            string serverToken = HttpContext.Current.Session["Token"].ToString();
            if (clientToken.Equals(serverToken))
                return true;
            else
                return false;
        }
    }
}