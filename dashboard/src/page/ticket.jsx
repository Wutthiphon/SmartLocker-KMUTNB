import React from "react";
import { useState } from "react";
import  Swal from "sweetalert2";
import Navbar from "../components/Navbar";
import Foot from "../components/Foot";

function Ticket() {
   const [email, setEmail] = useState("");
   const [ticket, setTicket] = useState("");
   const [loading, setLoading] = useState(false);

   const handleSubmit = async (e) => {
      e.preventDefault();
  
      if (!email.trim()) {
          Swal.fire({
              icon: "error",
              title: "กรุณากรอกอีเมล",
          });
          return;
      }
  
      setLoading(true);
  
      try {
          Swal.fire({
              title: "กำลังโหลด",
              allowOutsideClick: false,
              didOpen: () => Swal.showLoading(),
          });
  
          const res = await fetch(`https://52.62.242.78/api/ticket/seat/${email}`);
          

          if (!res.ok) {
             if(res.status === 404){
                Swal.fire({
                     icon: "error",
                     title: "ไม่พบข้อมูลการจอง",
                  });
                return;
             }else if (res.status === 400){
                const data = await res.json();
                Swal.fire({
                    icon: "warning",
                    title: data.status,
                    text: "กรุณารอการยืนยันการชำระเงิน",
                });
                return;
             }
          }
  
          const blob = await res.blob();
  
         
  
          const imageUrl = URL.createObjectURL(blob);
          setTicket(imageUrl);
          Swal.fire({
              icon: "success",
              title: "แสดงบัตรเข้างานพาแลงพระนครเหนือ",
          });
  
      } catch (error) {
          console.error("Error:", error);
          Swal.fire({
              icon: "error",
              title: error.message || "เกิดข้อผิดพลาดในการดึงข้อมูล",
          });
      } finally {
          setLoading(false);
      }
  };
  


  return (
    <div>
      <Navbar />
      <div className="bg-neutral-200 min-h-screen">
        <div className="py-10">
          <div className="container mx-auto px-4 sm:px-6 lg:px-10">
            <div className="bg-white p-6 rounded-lg shadow-lg">
              <div className="flex flex-col items-center">
                {/* Logo */}
                <img src="https://iili.io/2DAMRoJ.png" alt="logo" className="w-72 h-72"/>              {/* Event Title */}
                <div className="text-center text-lg text-orange-800 mt-4">
                  <h1 className="text-2xl font-bold mt-4">
                    เเสดงบัตรเข้างานพาแลงพระนครเหนือ
                  </h1>
                </div>

                {/* Event Description */}
                <div className="text-center text-lg text-gray-900 mt-4">
                  งานพาแลง ครั้งที่ 45 จัดโดยชมรมอีสาน
                  มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ
                </div>

                {/* Form Section */}
                <div className="w-full md:w-1/2 mt-4">
                  <form className="mb-4" onSubmit={handleSubmit}>
                    {/* Phone Number */}
                    <label className="block text-gray-700 text-sm font-bold mb-2">
                      email (ที่ลงทะเบียน)
                    </label>
                    <input
                        type="email"
                      className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-orange-700 focus:border-orange-800 block w-full p-2.5"
                      id="email"
                      name="email"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                      placeholder="อีเมล"
                    />

                    {/* Button */}
                    <div className="mt-6  text-center ">
                      <button
                        className="bg-orange-700 hover:bg-orange-800 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
                        type="submit"
                      >
                        เเสดงบัตร
                      </button>
                    </div>
                  </form>
                </div>
                 { ticket && (
                      <div className="mt-6">
                        <div className="flex justify-center">
                           <h3 className="text-lg font-bold">บัตรเข้างาน</h3>
                        </div>

                        <div className="flex justify-center mt-6">  
                           <img src={ticket} alt
                           ="ticket"  class="w-full h-auto max-w-xl rounded-lg" />


                        

                        </div>
                        </div>


                   )}

              </div> 
            </div>
          </div>
          <Foot />
        </div>
      </div>

    </div>
  );
}

export default Ticket;

               


