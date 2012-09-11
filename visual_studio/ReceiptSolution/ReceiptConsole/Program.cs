using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ReceiptLib;
using System.IO;



namespace ReceiptConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            FileInfo infile = new FileInfo("C:\\temp1\\montessori.jpg");

            Console.Write("What text to write? ");
            string txt = Console.ReadLine();

            FileInfo outfile = ReceiptTool.WriteOnImage(txt, infile);

            Console.WriteLine(string.Format("\nWrote '{0}' to {1}", txt, outfile.FullName));

            Console.WriteLine("\nPress any key to end.");
            Console.ReadKey(true);
        }
    }
}
