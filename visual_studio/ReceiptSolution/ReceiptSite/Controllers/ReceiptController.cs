using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ReceiptSite.Models;
using PagedList;
using System.IO;

namespace ReceiptSite.Controllers
{
    public class ReceiptController : Controller
    {
        private ReceiptsEntities context = new ReceiptsEntities();


        public ViewResult Index(string sortOrder, string currentNameFilter, string nameSearch, int? page)
        {
            ViewBag.Message = "Receipt List";

            //ViewBag.ReceiptDir = context.;

            ViewBag.CurrentSort = sortOrder;
            ViewBag.DateSortParm = String.IsNullOrEmpty(sortOrder) ? "Date desc" : "";
            ViewBag.NameSortParm = sortOrder == "Name" ? "Name desc" : "Name";

            if (Request.HttpMethod == "GET")
            {
                nameSearch = currentNameFilter;
            }
            else
            {
                page = 1;
            }

            ViewBag.currentNameFilter = nameSearch;

            var receipts = from r in context.Receipts select r;


            if (!String.IsNullOrEmpty(nameSearch))
            {
                receipts = receipts.Where(r => r.Name.ToUpper().Contains(nameSearch.ToUpper()));
            }


            switch (sortOrder)
            {
                case "Date desc":
                    receipts = receipts.OrderByDescending(r => r.CreateDate).ThenBy(r => r.id);
                    break;
                case "Name":
                    receipts = receipts.OrderBy(r => r.id).ThenBy(r => r.CreateDate);
                    break;
                case "Name desc":
                    receipts = receipts.OrderByDescending(r => r.id).ThenBy(r => r.CreateDate);
                    break;
                default:
                    receipts = receipts.OrderBy(r => r.CreateDate).ThenBy(r => r.id);
                    break;
            }
            
            int pageSize = 5;
            int pageNumber = (page ?? 1);
            return View(receipts.ToPagedList(pageNumber, pageSize));

        }


        public ActionResult Create()
        {
            // blank image dropdown
            //context.ReceiptBlankImages.Include(a => a.Genre).Include(a => a.Artist);

            //var blanks = (context.ReceiptBlankImages).OrderByDescending(e => e);

            var blanks = from i in context.ImageBanks
                         where i.ImageType.Equals('B')
                         select i;

            ViewBag.BlankImageList = new SelectList(blanks, "Id", "Id");

            return View();
        }

        [HttpPost]
        public ActionResult Create(Receipt receipt)
        {
            if (ModelState.IsValid)
            {
                return View(receipt); 
                //context.Add(receipt);
                //return RedirectToAction("Details", new { id = receipt.id });
            }

            return View(receipt);
        }

        public ViewResult Details(int id)
        {
            Receipt receipt = context.Receipts.Find(id);
            return View(receipt);
        }


        public ActionResult Edit(int id)
        {
            Receipt receipt = context.Receipts.Find(id);
       
            var blankImages = context.ImageBanks.Where(i => i.ImageType.Equals("B"));
            var receiptImages = context.ImageBanks.Where(i => i.ImageType.Equals("R"));

            ViewData["blankImageList"] = 
                new SelectList(blankImages, "Id", "ImageFilePath", receipt.BlankImageId);
            ViewData["receiptImageList"] =
                new SelectList(receiptImages, "Id", "ImageFilePath", receipt.ReceiptImageId);

            return View(receipt);
        }

    
        [HttpPost]
        public ActionResult Edit(Receipt r)
        {
            if (ModelState.IsValid)
            {
                context.Entry(r).State = EntityState.Modified;
                context.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(r);
        }

    }
}
