import React, { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";

const ResetPassword = () => {
  const { uid, token } = useParams();
  const history = useNavigate();
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [error, setError] = useState("");
  const [successMessage, setSuccessMessage] = useState("");

  const handleResetPassword = async () => {
    if (newPassword !== confirmPassword) {
      setError("Passwords do not match");
      return;
    }

    try {
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/reset-password/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            uid,
            token,
            new_password: newPassword,
          }),
        }
      );

      if (response.ok) {
        setSuccessMessage("Password has been reset successfully!");
        setTimeout(() => {
          history.push("/login"); // Redirect to login page after success
        }, 2000);
      } else {
        const data = await response.json();
        setError(data.error || "Failed to reset password. Please try again.");
      }
    } catch (err) {
      setError("An error occurred. Please try again.");
    }
  };

  return (
    <div className="w-full h-screen flex flex-col items-center justify-center bg-n-8">
      <div className="w-full max-w-[400px] bg-white rounded-lg shadow-lg p-8">
        <h1 className="text-2xl font-bold text-center text-n-8 mb-6">
          Reset Password
        </h1>

        {error && <p className="text-red-500 text-center mb-4">{error}</p>}
        {successMessage && (
          <p className="text-green-500 text-center mb-4">{successMessage}</p>
        )}

        <input
          type="password"
          placeholder="New Password"
          value={newPassword}
          onChange={(e) => setNewPassword(e.target.value)}
          className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
        />

        <input
          type="password"
          placeholder="Confirm New Password"
          value={confirmPassword}
          onChange={(e) => setConfirmPassword(e.target.value)}
          className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
        />

        <button
          onClick={handleResetPassword}
          className="w-full bg-blue-500 text-white font-semibold rounded-md py-3 mt-4 hover:bg-blue-600"
        >
          Reset Password
        </button>
      </div>
    </div>
  );
};

export default ResetPassword;
