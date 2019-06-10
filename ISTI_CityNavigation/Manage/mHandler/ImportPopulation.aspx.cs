﻿using System;
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
    public partial class ImportPopulation : System.Web.UI.Page
    {
        Population_DB PL_DB = new Population_DB();
        //建立共用參數
        string strErrorMsg = "";
        string strMaxVersion = "";
        string chkYear = "";
        DateTime dtNow = DateTime.Now;
        protected void Page_Load(object sender, EventArgs e)
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
            dt.Columns.Add("P_CityName", typeof(string));
            dt.Columns.Add("P_AreaYear", typeof(string));
            dt.Columns.Add("P_Area", typeof(string));
            dt.Columns.Add("P_TotalYear", typeof(string));
            dt.Columns.Add("P_PeopleTotal", typeof(string));
            dt.Columns.Add("P_PeopleTotalPercentYear", typeof(string));
            dt.Columns.Add("P_PeopleTotalPercent", typeof(string));
            dt.Columns.Add("P_Year", typeof(string));
            dt.Columns.Add("P_Child", typeof(string));
            dt.Columns.Add("P_ChildPercent", typeof(string));
            dt.Columns.Add("P_Teenager", typeof(string));
            dt.Columns.Add("P_TeenagerPercent", typeof(string));
            dt.Columns.Add("P_OldMen", typeof(string));
            dt.Columns.Add("P_OldMenPercent", typeof(string));
            dt.Columns.Add("P_CreateDate", typeof(DateTime));
            dt.Columns.Add("P_CreateID", typeof(string));
            dt.Columns.Add("P_CreateName", typeof(string));
            dt.Columns.Add("P_Status", typeof(string));
            dt.Columns.Add("P_Version", typeof(string));

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

                    //簡易判斷這份Excel是不是人口的Excel
                    int cellsCount = sheet.GetRow(0).Cells.Count;
                    //1.判斷表頭欄位數
                    if (cellsCount != 10)
                    {
                        throw new Exception("請檢查是否為土地人口的匯入檔案");
                    }
                    //2.檢查欄位名稱
                    if (sheet.GetRow(0).GetCell(1).ToString().Trim() != "土地面積" || sheet.GetRow(0).GetCell(2).ToString().Trim() != "年底戶籍總人口數")
                    {
                        throw new Exception("請檢查是否為土地人口的匯入檔案");
                    }

                    //取得當前最大版次
                    strMaxVersion = (Convert.ToInt32(PL_DB.getMaxVersin()) + 1).ToString();

                    //資料從第四筆開始 最後一筆是合計不進資料庫
                    for (int j = 3; j < sheet.PhysicalNumberOfRows - 1; j++)
                    {
                        if (sheet.GetRow(j).GetCell(0).ToString().Trim() != "" && sheet.GetRow(j).GetCell(0).ToString().Trim() != "全台平均")
                        {
                            DataRow row = dt.NewRow();
                            row["P_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                            row["P_AreaYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//土地面積-年
                            row["P_Area"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//土地面積
                            row["P_TotalYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年", "");//年底戶籍總人口數-年
                            row["P_PeopleTotal"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//年底戶籍總人口數
                            row["P_PeopleTotalPercentYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//年底戶籍總人口數成長率-年
                            row["P_PeopleTotalPercent"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//年底戶籍總人口數成長率
                            row["P_Year"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//年
                            row["P_Child"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//0-14歲幼年人口數
                            row["P_ChildPercent"] = sheet.GetRow(j).GetCell(7).ToString().Trim();//0-14歲幼年人比例
                            row["P_Teenager"] = sheet.GetRow(j).GetCell(5).ToString().Trim();//15-64歲青壯年人口數
                            row["P_TeenagerPercent"] = sheet.GetRow(j).GetCell(8).ToString().Trim();//15-64歲青壯年人比例
                            row["P_OldMen"] = sheet.GetRow(j).GetCell(6).ToString().Trim();//65歲以上老年人口數
                            row["P_OldMenPercent"] = sheet.GetRow(j).GetCell(9).ToString().Trim();//65歲以上老年人比例
                            row["P_CreateDate"] = dtNow;
                            row["P_CreateID"] = LogInfo.mGuid;//上傳者GUID
                            row["P_CreateName"] = LogInfo.name;//上傳者姓名
                            row["P_Status"] = "A";
                            row["P_Version"] = strMaxVersion;

                            if (chkYear == "")
                                chkYear = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");

                            dt.Rows.Add(row);
                        }

                    }

                    if (dt.Rows.Count > 0)
                    {
                        BeforeBulkCopy(oConn, myTrans, chkYear);//檢查資料表裡面是不是有該年的資料
                        DoBulkCopy(myTrans, dt, strErrorMsg);//匯入
                        //最後再commit
                        myTrans.Commit();
                        if (strErrorMsg == "")
                        {
                            strErrorMsg = "上傳成功";
                        }

                    }
                }

            }
            catch (Exception ex)
            {
                strErrorMsg += ex.Message;
                myTrans.Rollback();
            }
            finally
            {
                oCmd.Connection.Close();
                oConn.Close();
                Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg + "');</script>");
            }

        }


        //insert 前判斷是不是同年份有資料了
        static void BeforeBulkCopy(SqlConnection oConn, SqlTransaction oTran, string chkYear)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"
                declare @chkRowCount int = 0;
                select @chkRowCount = count(*) from Population where P_Year=@chkYear and P_Status='A'

                if @chkRowCount>0
                    begin
                        update Population set P_Status='D' where P_Year=@chkYear and P_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Parameters.AddWithValue("@chkYear", chkYear);

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //常住人口 BulkCopy
        void DoBulkCopy(SqlTransaction oTran, DataTable srcData, string errorMsg)
        {
            try
            {
                SqlBulkCopyOptions setting = SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.TableLock;
                using (SqlBulkCopy sqlBC = new SqlBulkCopy(oTran.Connection, setting, oTran))
                {
                    sqlBC.BulkCopyTimeout = 600; ///設定逾時的秒數
                    //sqlBC.BatchSize = 1000; ///設定一個批次量寫入多少筆資料, 設定值太小會影響效能 
                    ////設定 NotifyAfter 屬性，以便在每複製 10000 個資料列至資料表後，呼叫事件處理常式。
                    //sqlBC.NotifyAfter = 10000;
                    ///設定要寫入的資料庫
                    sqlBC.DestinationTableName = "Population";

                    /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
                    sqlBC.ColumnMappings.Add("P_CityName", "P_CityName");
                    sqlBC.ColumnMappings.Add("P_AreaYear", "P_AreaYear");
                    sqlBC.ColumnMappings.Add("P_Area", "P_Area");
                    sqlBC.ColumnMappings.Add("P_TotalYear", "P_TotalYear");
                    sqlBC.ColumnMappings.Add("P_PeopleTotal", "P_PeopleTotal");
                    sqlBC.ColumnMappings.Add("P_PeopleTotalPercentYear", "P_PeopleTotalPercentYear");
                    sqlBC.ColumnMappings.Add("P_PeopleTotalPercent", "P_PeopleTotalPercent");
                    sqlBC.ColumnMappings.Add("P_Year", "P_Year");
                    sqlBC.ColumnMappings.Add("P_Child", "P_Child");
                    sqlBC.ColumnMappings.Add("P_ChildPercent", "P_ChildPercent");
                    sqlBC.ColumnMappings.Add("P_Teenager", "P_Teenager");
                    sqlBC.ColumnMappings.Add("P_TeenagerPercent", "P_TeenagerPercent");
                    sqlBC.ColumnMappings.Add("P_OldMen", "P_OldMen");
                    sqlBC.ColumnMappings.Add("P_OldMenPercent", "P_OldMenPercent");
                    sqlBC.ColumnMappings.Add("P_CreateDate", "P_CreateDate");
                    sqlBC.ColumnMappings.Add("P_CreateID", "P_CreateID");
                    sqlBC.ColumnMappings.Add("P_CreateName", "P_CreateName");
                    sqlBC.ColumnMappings.Add("P_Status", "P_Status");
                    sqlBC.ColumnMappings.Add("P_Version", "P_Version");


                    //P_CityName
                    //P_AreaYear
                    //P_Area
                    //P_TotalYear
                    //P_PeopleTotal
                    //P_PeopleTotalPercentYear
                    //P_PeopleTotalPercent
                    //P_Year
                    //P_Child
                    //P_ChildPercent
                    //P_Teenager
                    //P_TeenagerPercent
                    //P_OldMen
                    //P_OldMenPercent
                    //P_CreateDate
                    //P_CreateID
                    //P_CreateName
                    //P_Status
                    //P_Version

                    /// 開始寫入資料
                    sqlBC.WriteToServer(srcData);
                }
            }
            catch (Exception ex)
            {
                strErrorMsg += "人口匯入 error：" + ex.Message.ToString() + "\n";
            }

        }
    }
}