import React, { useState , useEffect } from "react";
import Navbar from "../components/Navbar";
import cookie from "js-cookie";
import Foot from "../components/Foot";
import { AiOutlineLogin } from "react-icons/ai";
import Swal from "sweetalert2";




function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const  [show_error , setShow_error] = useState(false);
  const [loading, setLoading] = useState(false);



  
  const handleSubmit = async (e) => {
   e.preventDefault();

   if (!email.trim() || !password.trim()) {
       setError("กรุณากรอกข้อมูลให้ครบถ้วน");
       setShow_error(true);
       return;
   }

   setLoading(true);

   try {
       Swal.fire({
           title: "กำลังเข้าสู่ระบบ...",
           allowOutsideClick: false,
           didOpen: () => Swal.showLoading(),
       });

       const res = await fetch("https://52.62.242.78/api/auth/login", {
           method: "POST",
           headers: {
               "Content-Type": "application/json",
           },
           body: JSON.stringify({ email, password }),
       });

       const data = await res.json();


       if (res.ok) {
           Swal.fire({
               icon: "success",
               title: "เข้าสู่ระบบสำเร็จ",
               showConfirmButton: false,
               timer: 1500,
           });

           setLoading(false);
           cookie.set("accessToken",  data.accessToken);
           cookie.set("role", "admin");


        


         
           window.location.href = "/page/dashboard";
       } else {
           Swal.fire({
               icon: "error",
               title: "เข้าสู่ระบบไม่สำเร็จ",
               text: data.message || "เกิดข้อผิดพลาด",
           });
       }
   } catch (err) {
       console.error("เกิดข้อผิดพลาด:", err);
       Swal.fire({
           icon: "error",
           title: "เกิดข้อผิดพลาด",
           text: "ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้",
        
         
       });
   } finally {
       setLoading(false);
   }
};

  return (
    <div>
      <Navbar />
      <div className="flex items-center justify-center min-h-screen bg-neutral-200">
        <div className="w-full max-w-sm p-8 bg-white rounded-lg shadow-md">
          <div className="mb-6 text-center">
            {/* <AiOutlineLogin className="w-20 h-20 text-orange-800 mx-auto" /> */}
            <img src="https://iili.io/2DAMRoJ.png" className="w-48 h-48 text-orange-800  mx-auto" />
            <h3 className="text-2xl font-bold text-gray-700 mb-6">
              เข้าสู่ระบบ ชมรมอีสาน
            </h3>
          </div>
          <form  onSubmit={handleSubmit}>
            <div className="mb-4">
              <label
                htmlFor="username"
                className="block text-gray-700 text-sm font-bold mb-2"
              >
                E-mail
                {error && <p className="text-red-500 text-s italic">{error}</p>}
              </label>
              <input
                type="email"
                id="email"
                className="w-full p-2 border border-orange-700 rounded"
                onChange={(e) => setEmail(e.target.value)}
               {...(show_error ? {style: {borderColor: "red"}} : {})}
              />
            </div>
            <div className="mb-6">
              <label
                htmlFor="password"
                className="block text-gray-700 text-sm font-bold mb-2"
              >
                รหัสผ่าน
              </label>
              <input
                type="password"
                id="password"
                className="w-full p-2 border border-orange-700 rounded"
                {...(show_error ? {style: {borderColor: "red"}} : {})}
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>
            <button
              type="submit"
              className="w-full bg-orange-800 hover:bg-orange-600 text-white font-bold py-2 rounded"
            >
              เข้าสู่ระบบ
            </button>
          </form>
          <div className="text-center mt-4">
            <a href="#" className="text-sm text-orange-600 hover:text-orange-700">
              ลืมรหัสผ่าน?
            </a>
          </div>
          <div className="flex items-center justify-center mt-6">
            <div className="w-full h-px bg-gray-300"></div>
            <div className="mx-2 text-sm text-gray-500">หรือ</div>
            <div className="w-full h-px bg-gray-300"></div>
          </div>
        </div> 
        
      </div>
      <Foot />
    
    </div>
  );
}

export default Login;