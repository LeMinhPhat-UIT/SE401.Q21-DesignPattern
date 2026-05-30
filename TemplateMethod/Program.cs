using System;

public abstract class ReportGenerator
{
    // Template Method
    public void GenerateReport()
    {
        FetchData();
        ProcessData();
        ExportReport();

        if (ShouldNotify())
        {
            SendNotification();
        }
    }

    protected void FetchData()
    {
        Console.WriteLine("Fetching data from database...");
    }

    protected void ProcessData()
    {
        Console.WriteLine("Processing report data...");
    }

    // Bước bắt buộc class con phải định nghĩa
    protected abstract void ExportReport();

    // Hook method: class con có thể override hoặc không
    protected virtual bool ShouldNotify()
    {
        return true;
    }

    protected void SendNotification()
    {
        Console.WriteLine("Sending report notification...");
    }
}

public class PdfReportGenerator : ReportGenerator
{
    protected override void ExportReport()
    {
        Console.WriteLine("Exporting report as PDF file...");
    }
}

public class ExcelReportGenerator : ReportGenerator
{
    protected override void ExportReport()
    {
        Console.WriteLine("Exporting report as Excel file...");
    }

    protected override bool ShouldNotify()
    {
        return false;
    }
}

public class Program
{
    public static void Main()
    {
        ReportGenerator pdfReport = new PdfReportGenerator();
        pdfReport.GenerateReport();

        Console.WriteLine();

        ReportGenerator excelReport = new ExcelReportGenerator();
        excelReport.GenerateReport();
    }
}