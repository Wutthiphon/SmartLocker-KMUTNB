import React from "react";
import Navbar from "../components/Navbar";
import { Link } from "react-router-dom";
import Swal from "sweetalert2";
import Foot from "../components/Foot";

function About() {

   const Show_image = (URL) => {
     Swal.fire({
      html: `<img src="${URL}" />`,
      showCancelButton: true,
      confirmButtonText: "ปิด",
    });
  };


  return (
    <div className="bg-neutral-200 min-h-screen">
      <Navbar />
      <section className="py-20">
        <div className="container mx-auto ">
      

          {/* Grid Section */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">

              <div className="bg-white p-3 rounded-lg shadow-lg  ">
                <img
                  src="https://iili.io/2DAw3t1.png"
                    
                  className="w-96 h-96 justify-center"
                />
                <h3 className="text-2xl font-semibold mt-4">ผังที่นั่งงาน</h3>
                <p className="text-gray-500 mt-2">
                  งานพาแลง ครั้งที่ 45 จัดโดยชมรมอีสาน มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ
                </p>
                <div className="mt-4">
                  <div className="flex justify-start">
                  <button class="text-white bg-indigo-500 hover:bg-indigo-400 focus:outline-none focus:ring-4 focus:ring-indigo-300 font-medium rounded-full text-sm px-5 py-2.5 text-center me-2 mb-2"
                  onClick={() => Show_image("https://iili.io/2DAw3t1.png")}>
                   ดูรายละเอียด
                  </button>
                  </div>
                  </div>
              </div>

              <div className="bg-white p-3 rounded-lg shadow-lg ">
                <img
                  src="https://iili.io/2DWNxGn.jpg"
                  className="w-96 h-96 "
                />
                <h3 className="text-2xl font-semibold mt-4">รายการอาหารในงาน</h3>
                <p className="text-gray-500 mt-2">
                  งานพาแลง ครั้งที่ 45 จัดโดยชมรมอีสาน มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ
                </p>
                <div className="mt-4">
                  <div className="flex justify-start">
                  <button class="text-white bg-indigo-500 hover:bg-indigo-400 focus:outline-none focus:ring-4 focus:ring-indigo-300 font-medium rounded-full text-sm px-5 py-2.5 text-center me-2 mb-2"
                  onClick={() => Show_image("https://iili.io/2DWNxGn.jpg")}
                  >
                    ดูรายละเอียด
                  </button>
                  </div>
                  </div>
              </div>

              <div className="bg-white p-3 rounded-lg shadow-lg  ">
                <img
                  src="https://iili.io/2DWNCQt.jpg"
                  className="w-96 h-96 "
                />
                <h3 className="text-2xl font-semibold mt-4">รายละเอียดบัตร</h3>
                <p className="text-gray-500 mt-2">
                  งานพาแลง ครั้งที่ 45 จัดโดยชมรมอีสาน มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ
                </p>
                <div className="mt-4">
                  <div className="flex justify-start">
                  <button class="text-white bg-indigo-500 hover:bg-indigo-400 focus:outline-none focus:ring-4 focus:ring-indigo-300 font-medium rounded-full text-sm px-5 py-2.5 text-center me-2 mb-2"
                  onClick={() => Show_image("https://iili.io/2DWNCQt.jpg")}
                  >
                     ดูรายละเอียด
                  </button>
                  </div>
                  </div>
              </div>

              <div className="bg-white p-3 rounded-lg shadow-lg  ">
                <img
                  src="https://iili.io/2DWteVe.png"
                  className="w-96 h-96 "
                />
                <h3 className="text-2xl font-semibold mt-4">วิธีการจอง</h3>
                <p className="text-gray-500 mt-2">
                  งานพาแลง ครั้งที่ 45 จัดโดยชมรมอีสาน มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ
                </p>
                <div className="mt-4">
                  <div className="flex justify-start">
                  <button class="text-white bg-indigo-500 hover:bg-indigo-400 focus:outline-none focus:ring-4 focus:ring-indigo-300 font-medium rounded-full text-sm px-5 py-2.5 text-center me-2 mb-2"
                  onClick={() => Show_image("https://iili.io/2DWteVe.png")}
                  >
                     ดูรายละเอียด
                  </button>
                  </div>
                  </div>
              </div>
  
          </div>

          </div>
        
      </section>
      <Foot />
    </div>
  );
}

export default About;


