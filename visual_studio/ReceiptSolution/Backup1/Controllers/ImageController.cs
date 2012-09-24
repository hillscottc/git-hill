using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ReceiptSite.Models;

namespace ReceiptSite.Controllers
{ 
    public class ImageController : Controller
    {
        private ReceiptsEntities db = new ReceiptsEntities();

        //
        // GET: /Image/

        public ViewResult Index()
        {
            return View(db.ImageBanks.ToList());
        }

        //
        // GET: /Image/Details/5

        public ViewResult Details(int id)
        {
            ImageBank imagebank = db.ImageBanks.Find(id);
            return View(imagebank);
        }

        //
        // GET: /Image/Create

        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /Image/Create

        [HttpPost]
        public ActionResult Create(ImageBank imagebank)
        {
            if (ModelState.IsValid)
            {
                db.ImageBanks.Add(imagebank);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            return View(imagebank);
        }
        
        //
        // GET: /Image/Edit/5
 
        public ActionResult Edit(int id)
        {
            ImageBank imagebank = db.ImageBanks.Find(id);
            return View(imagebank);
        }

        //
        // POST: /Image/Edit/5

        [HttpPost]
        public ActionResult Edit(ImageBank imagebank)
        {
            if (ModelState.IsValid)
            {
                db.Entry(imagebank).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(imagebank);
        }

        //
        // GET: /Image/Delete/5
 
        public ActionResult Delete(int id)
        {
            ImageBank imagebank = db.ImageBanks.Find(id);
            return View(imagebank);
        }

        //
        // POST: /Image/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            ImageBank imagebank = db.ImageBanks.Find(id);
            db.ImageBanks.Remove(imagebank);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}