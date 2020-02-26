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
    public partial class ImportTravel : System.Web.UI.Page
    {
        Travel_DB TL_DB = new Travel_DB();
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
                dt.Columns.Add("T_CityNo", typeof(string)).MaxLength=2;
                dt.Columns.Add("T_CityName", typeof(string)).MaxLength=10;
                dt.Columns.Add("T_HotelUseYear", typeof(string)).MaxLength=3;
                dt.Columns.Add("T_HotelUseRate", typeof(string)).MaxLength=7;
                dt.Columns.Add("T_PointYear", typeof(string)).MaxLength=3;
                dt.Columns.Add("T_PointYearDesc", typeof(string)).MaxLength=50;
                dt.Columns.Add("T_PointPeople", typeof(string)).MaxLength=20;
                dt.Columns.Add("T_HotelsYear", typeof(string)).MaxLength=3;
                dt.Columns.Add("T_Hotels", typeof(string)).MaxLength=20;
                dt.Columns.Add("T_HotelRoomsYear", typeof(string)).MaxLength=3;
                dt.Columns.Add("T_HotelRooms", typeof(string)).MaxLength = 20;
                dt.Columns.Add("T_HotelAvgPriceYear", typeof(string)).MaxLength=3;
                dt.Columns.Add("T_HotelAvgPrice", typeof(string)).MaxLength=20;
                dt.Columns.Add("T_CreateDate", typeof(DateTime));
                dt.Columns.Add("T_CreateID", typeof(string));
                dt.Columns.Add("T_CreateName", typeof(string));
                dt.Columns.Add("T_Status", typeof(string));
                dt.Columns.Add("T_Version", typeof(int));
                
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

                        //簡易判斷這份Excel是不是觀光的Excel
                        int cellsCount = sheet.GetRow(0).Cells.Count;
                        //1.判斷表頭欄位數
                        if (cellsCount != 6)
                        {
                            throw new Exception("請檢查是否為觀光的匯入檔案");
                        }
                        //2.檢查欄位名稱
                        if (sheet.GetRow(0).GetCell(1).ToString().Trim() != "觀光旅館住用率" || sheet.GetRow(0).GetCell(2).ToString().Trim() != "觀光遊憩據點(縣市)人次統計")
                        {
                            throw new Exception("請檢查是否為觀光的匯入檔案");
                        }

                        //取得當前最大版次 (+1變成現在版次)
                        strMaxVersion = TL_DB.getMaxVersin() + 1;

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
                                row["T_CityNo"] = cityNo;//縣市代碼
                                row["T_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                                row["T_HotelUseYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//觀光旅館住用率-資料年度(民國年)
                                row["T_HotelUseRate"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//觀光旅館住用率
                                row["T_PointYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年(統計至107年11月)", "");//觀光遊憩據點(縣市)人次統計-資料年度(民國年)  ex: 107年(統計至107年11月)  存 107
                                row["T_PointYearDesc"] = sheet.GetRow(1).GetCell(2).ToString().Trim();//觀光遊憩據點(縣市)人次統計-資料年度(民國年)  ex: 107年(統計至107年11月)  存 107年(統計至107年11月)
                                row["T_PointPeople"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//觀光遊憩據點(縣市)人次統計-人次
                                row["T_HotelsYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//觀光旅館家數-資料年度(民國年)
                                row["T_Hotels"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//觀光旅館家數-家
                                row["T_HotelRoomsYear"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//觀光旅館房間數-資料年度(民國年)
                                row["T_HotelRooms"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//觀光旅館房間數-間
                                row["T_HotelAvgPriceYear"] = sheet.GetRow(1).GetCell(5).ToString().Trim().Replace("年", "");//觀光旅館平均房價-資料年度(民國年)
                                row["T_HotelAvgPrice"] = sheet.GetRow(j).GetCell(5).ToString().Trim();//觀光旅館平均房價-元
                                row["T_CreateDate"] = dtNow;
                                row["T_CreateID"] = LogInfo.mGuid;//上傳者GUID
                                row["T_CreateName"] = LogInfo.name;//上傳者姓名
                                row["T_Status"] = "A";
                                row["T_Version"] = strMaxVersion;

                                dt.Rows.Add(row);
                            }
                        }

                        if (dt.Rows.Count > 0)
                        {
                            strErrorMsg = "";
                            BeforeBulkCopy(oConn, myTrans);//檢查資料表裡面是不是有該年的資料
                            DoBulkCopy(myTrans, dt, strErrorMsg);//匯入
                                                                 //最後再commit
                            myTrans.Commit();
                            

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
                        idl_db._IDL_Description = "檔案類別:觀光 , 狀態：上傳成功";
                        idl_db._IDL_ModId = LogInfo.mGuid;
                        idl_db._IDL_ModName = LogInfo.name;
                        idl_db.addLog();
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('觀光匯入成功');</script>");
                    }
                    else
                    {
                        /// Log
                        idl_db._IDL_Type = "ISTI";
                        idl_db._IDL_IP = Common.GetIPv4Address();
                        idl_db._IDL_Description = "檔案類別:觀光 , 狀態：上傳失敗";
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
                select @chkRowCount = count(*) from Travel where T_Status='A'

                if @chkRowCount>0
                    begin
                        update Travel set T_Status='D' where T_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //觀光 BulkCopy
        private void DoBulkCopy(SqlTransaction oTran, DataTable srcData, string errorMsg)
        {
            //try
            //{
                SqlBulkCopyOptions setting = SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.TableLock;
                using (SqlBulkCopy sqlBC = new SqlBulkCopy(oTran.Connection, setting, oTran))
                {
                    sqlBC.BulkCopyTimeout = 600; ///設定逾時的秒數
                    //sqlBC.BatchSize = 1000; ///設定一個批次量寫入多少筆資料, 設定值太小會影響效能 
                    ////設定 NotifyAfter 屬性，以便在每複製 10000 個資料列至資料表後，呼叫事件處理常式。
                    //sqlBC.NotifyAfter = 10000;
                    ///設定要寫入的資料庫
                    sqlBC.DestinationTableName = "Travel";

                    /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
                    sqlBC.ColumnMappings.Add("T_CityNo", "T_CityNo");
                    sqlBC.ColumnMappings.Add("T_CityName", "T_CityName");
                    sqlBC.ColumnMappings.Add("T_HotelUseYear", "T_HotelUseYear");
                    sqlBC.ColumnMappings.Add("T_HotelUseRate", "T_HotelUseRate");
                    sqlBC.ColumnMappings.Add("T_PointYear", "T_PointYear");
                    sqlBC.ColumnMappings.Add("T_PointYearDesc", "T_PointYearDesc");
                    sqlBC.ColumnMappings.Add("T_PointPeople", "T_PointPeople");
                    sqlBC.ColumnMappings.Add("T_HotelsYear", "T_HotelsYear");
                    sqlBC.ColumnMappings.Add("T_Hotels", "T_Hotels");
                    sqlBC.ColumnMappings.Add("T_HotelRoomsYear", "T_HotelRoomsYear");
                    sqlBC.ColumnMappings.Add("T_HotelRooms", "T_HotelRooms");
                    sqlBC.ColumnMappings.Add("T_HotelAvgPriceYear", "T_HotelAvgPriceYear");
                    sqlBC.ColumnMappings.Add("T_HotelAvgPrice", "T_HotelAvgPrice");
                    sqlBC.ColumnMappings.Add("T_CreateDate", "T_CreateDate");
                    sqlBC.ColumnMappings.Add("T_CreateID", "T_CreateID");
                    sqlBC.ColumnMappings.Add("T_CreateName", "T_CreateName");
                    sqlBC.ColumnMappings.Add("T_Status", "T_Status");
                    sqlBC.ColumnMappings.Add("T_Version", "T_Version");

                    /// 開始寫入資料
                    sqlBC.WriteToServer(srcData);
                }
            //}
            //catch (Exception ex)
            //{
            //    strErrorMsg += "觀光匯入 error：" + ex.Message.ToString() + "\n";
            //}

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