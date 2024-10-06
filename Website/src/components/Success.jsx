import React, { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import Confetti from "react-confetti";

const Success = () => {
  const navigate = useNavigate(); // Verwende useNavigate anstelle von useHistory

  // Automatische Weiterleitung zum Dashboard nach 5 Sekunden
  useEffect(() => {
    const timer = setTimeout(() => {
      navigate("/dashboard#pricingplans"); // Verwende navigate anstelle von history.push
    }, 5000);

    return () => clearTimeout(timer);
  }, [navigate]);

  return (
    <div className="flex flex-col items-center justify-center h-screen">
      <Confetti /> {/* Konfetti-Anzeige */}
      <h1 className="text-4xl font-bold mb-4">
        A warm welcome to the Aquaware community :D
      </h1>
      <p className="text-xl">You will be redirected shortly...</p>
    </div>
  );
};

export default Success;
