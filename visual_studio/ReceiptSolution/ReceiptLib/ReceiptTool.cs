using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.IO;

namespace ReceiptLib
{
    public static class ReceiptTool
    {

        public static FileInfo GetAppDir()
        {
            return new FileInfo(System.Reflection.Assembly.GetExecutingAssembly().Location);
        }

        private static FileInfo getOutFile(FileInfo infile)
        {
            return new FileInfo(infile.DirectoryName + "\\new_" + infile.Name);
        }

        public static FileInfo WriteOnImage(string txt, FileInfo inFile)
        {
            //HttpContext.Current.Server.MapPath
            //System.Drawing.Image bitmap = (System.Drawing.Image)Bitmap.FromFile(Server.MapPath("image\\img_tripod.jpg"));

            Image bitmap = (Image)Bitmap.FromFile(inFile.FullName);

            Font font = new Font("Arial", 20, FontStyle.Italic, GraphicsUnit.Pixel);

            Color color = Color.FromArgb(255, 255, 0, 0);
            Point atpoint = new Point(bitmap.Width / 2, bitmap.Height / 2);
            SolidBrush brush = new SolidBrush(color);
            Graphics graphics = Graphics.FromImage(bitmap);

            StringFormat sf = new StringFormat();
            sf.Alignment = StringAlignment.Center;
            sf.LineAlignment = StringAlignment.Center;

            graphics.DrawString(txt, font, brush, atpoint, sf);
            graphics.Dispose();

            using (MemoryStream memStream = new MemoryStream())
            using (FileStream fStream = File.OpenWrite(getOutFile(inFile).FullName))
            {
                bitmap.Save(memStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                byte[] msBytes = memStream.ToArray();
                fStream.Write(msBytes, 0, msBytes.Length);
            }

            //ms.WriteTo(Response.OutputStream);

            return getOutFile(inFile);           
        } 



    }
}
