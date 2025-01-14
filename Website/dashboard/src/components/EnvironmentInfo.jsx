import React, { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import Cookies from "js-cookie";
import { FaEdit, FaTrashAlt, FaPlus, FaSpinner } from "react-icons/fa";

const EnvironmentInfo = () => {
  const { t } = useTranslation();
  const [environments, setEnvironments] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isCreating, setIsCreating] = useState(false);
  const [isUpdating, setIsUpdating] = useState(false);
  const [isDeleting, setIsDeleting] = useState(false);
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [isEditModalOpen, setIsEditModalOpen] = useState(null);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(null);
  const [deleteInput, setDeleteInput] = useState("");
  const [formData, setFormData] = useState({
    name: "",
    description: "",
    environment_type: "aquarium",
    public: false,
    city: "",
  });

  const fetchEnvironments = async () => {
    try {
      setIsLoading(true);
      const apiKey = Cookies.get("api_key");

      const response = await fetch(
        "https://dev.aquaware.cloud/api/environments/",
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "x-api-key": apiKey,
          },
        }
      );

      if (response.ok) {
        const data = await response.json();
        console.log("Environments:", data);
        setEnvironments(data);
      } else {
        throw new Error(t("environment.fetchError"));
      }
    } catch (error) {
      console.error("Error fetching environments:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleCreateEnvironment = async () => {
    try {
      const apiKey = Cookies.get("api_key");

      const response = await fetch(
        "https://dev.aquaware.cloud/api/environments/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-api-key": apiKey,
          },
          body: JSON.stringify(formData),
        }
      );

      if (response.ok) {
        fetchEnvironments();
        setIsCreateModalOpen(false);
      } else {
        throw new Error(t("environment.createError"));
      }
    } catch (error) {
      console.error("Error creating environment:", error);
    }
  };

  const handleUpdateEnvironment = async (id) => {
    try {
      const apiKey = Cookies.get("api_key");

      const response = await fetch(
        `https://dev.aquaware.cloud/api/environments/${id}/`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            "x-api-key": apiKey,
          },
          body: JSON.stringify(formData),
        }
      );

      if (response.ok) {
        fetchEnvironments();
        setIsEditModalOpen(null);
      } else {
        throw new Error(t("environment.updateError"));
      }
    } catch (error) {
      console.error("Error updating environment:", error);
    }
  };

  const handleDeleteEnvironment = async (id) => {
    try {
      const apiKey = Cookies.get("api_key");

      const response = await fetch(
        `https://dev.aquaware.cloud/api/environments/${id}/`,
        {
          method: "DELETE",
          headers: {
            "x-api-key": apiKey,
          },
        }
      );

      if (response.ok) {
        fetchEnvironments();
        setIsDeleteModalOpen(null);
      } else {
        throw new Error(t("environment.deleteError"));
      }
    } catch (error) {
      console.error("Error deleting environment:", error);
    }
  };

  useEffect(() => {
    fetchEnvironments();
  }, []);

  const renderIcon = (type) => {
    switch (type) {
      case "aquarium":
        return "🐠";
      case "pond":
        return "🦆";
      case "lake":
        return "🏞️";
      case "sea":
        return "🌊";
      case "pool":
        return "🏊";
      case "other":
        return "🌍";
      default:
        return "❓";
    }
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-screen">
        <FaSpinner className="animate-spin text-4xl text-blue-500" />
      </div>
    );
  }

  return (
    <div className="p-4">
      <button
        className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
        onClick={() => setIsCreateModalOpen(true)}
      >
        <FaPlus />
        {t("environment.create_new_environment")}
      </button>

      <div className="mt-4 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {Array.isArray(environments) &&
          environments.map((env) => (
            <div
              key={env.id}
              className="flex items-center justify-between border border-n-6 rounded-lg p-4 shadow-lg bg-n-6"
            >
              <div className="flex items-center gap-4">
                <span className="text-2xl">
                  {renderIcon(env.environment_type)}
                </span>
                <div className="break-words">
                  <p className="text-sm text-n-3">ID: {env.id}</p>
                  <h3 className="text-lg font-semibold break-words">
                    {env.name}
                  </h3>
                  <p className="text-sm text-n-3 break-words">
                    {env.description}
                  </p>
                  <p className="text-sm text-n-4 break-words">{env.city}</p>
                </div>
              </div>
              <div className="flex flex-col gap-2">
                <button
                  className="text-blue-500 hover:text-blue-700"
                  onClick={() => {
                    const selectedEnvironment = environments.find(
                      (env) => env.id === env.id
                    );
                    setFormData({
                      name: selectedEnvironment.name,
                      description: selectedEnvironment.description,
                      environment_type: selectedEnvironment.environment_type,
                      public: selectedEnvironment.public,
                      city: selectedEnvironment.city || "",
                    });
                    setIsEditModalOpen(env.id);
                  }}
                >
                  <FaEdit size={20} />
                </button>
                <button
                  className="text-red-500 hover:text-red-700"
                  onClick={() => setIsDeleteModalOpen(env.id)}
                >
                  <FaTrashAlt size={20} />
                </button>
              </div>
            </div>
          ))}
      </div>

      {isCreateModalOpen && (
        <div className="fixed top-0 left-0 w-full h-full bg-n-8 bg-opacity-50 flex items-center justify-center">
          <div className="bg-n-6 p-6 rounded-lg shadow-lg">
            <h3 className="text-lg font-bold mb-4">
              {t("environment.create_environment")}
            </h3>
            <input
              type="text"
              placeholder={t("environment.name")}
              value={formData.name}
              onChange={(e) =>
                setFormData({ ...formData, name: e.target.value })
              }
              className="w-full mb-2 px-4 py-2 bg-n-8 border rounded-lg"
            />
            <textarea
              placeholder={t("environment.description")}
              value={formData.description}
              onChange={(e) =>
                setFormData({ ...formData, description: e.target.value })
              }
              className="w-full mb-2 px-4 py-2 border bg-n-8 rounded-lg"
            />
            <select
              value={formData.environment_type}
              onChange={(e) =>
                setFormData({ ...formData, environment_type: e.target.value })
              }
              className="w-full mb-2 px-4 py-2 border bg-n-8 rounded-lg"
            >
              <option value="aquarium">{t("environment.aquarium")}</option>
              <option value="pond">{t("environment.pond")}</option>
              <option value="lake">{t("environment.lake")}</option>
              <option value="sea">{t("environment.sea")}</option>
              <option value="pool">{t("environment.pool")}</option>
              <option value="other">{t("environment.other")}</option>
            </select>
            <input
              type="text"
              placeholder={t("environment.city")}
              value={formData.city}
              onChange={(e) =>
                setFormData({ ...formData, city: e.target.value })
              }
              className="w-full mb-2 px-4 py-2 border bg-n-8 rounded-lg"
            />
            <div className="flex justify-end gap-4">
              <button
                onClick={() => setIsCreateModalOpen(false)}
                className="px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-700"
              >
                {t("environment.cancel")}
              </button>
              <button
                onClick={() => {
                  setIsCreating(true);
                  handleCreateEnvironment().finally(() => setIsCreating(false));
                }}
                className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
                disabled={isCreating}
              >
                {isCreating ? (
                  <FaSpinner className="animate-spin" />
                ) : (
                  t("environment.create")
                )}
              </button>
            </div>
          </div>
        </div>
      )}

      {isEditModalOpen && (
        <div className="fixed top-0 left-0 w-full h-full bg-n-8 bg-opacity-50 flex items-center justify-center">
          <div className="bg-n-6 p-6 rounded-lg shadow-lg">
            <h3 className="text-lg font-bold mb-4">
              {t("environment.edit_environment")}
            </h3>
            <input
              type="text"
              placeholder={t("environment.name")}
              value={formData.name}
              onChange={(e) =>
                setFormData({ ...formData, name: e.target.value })
              }
              className="w-full bg-n-8 mb-2 px-4 py-2 border rounded-lg"
            />
            <textarea
              placeholder={t("environment.description")}
              value={formData.description}
              onChange={(e) =>
                setFormData({ ...formData, description: e.target.value })
              }
              className="w-full bg-n-8 mb-2 px-4 py-2 border rounded-lg"
            />
            <select
              value={formData.environment_type}
              onChange={(e) =>
                setFormData({ ...formData, environment_type: e.target.value })
              }
              className="w-full bg-n-8 mb-2 px-4 py-2 border rounded-lg"
            >
              <option value="aquarium">{t("environment.aquarium")}</option>
              <option value="pond">{t("environment.pond")}</option>
              <option value="lake">{t("environment.lake")}</option>
              <option value="sea">{t("environment.sea")}</option>
              <option value="pool">{t("environment.pool")}</option>
              <option value="other">{t("environment.other")}</option>
            </select>
            <input
              type="text"
              placeholder={t("environment.city")}
              value={formData.city}
              onChange={(e) =>
                setFormData({ ...formData, city: e.target.value })
              }
              className="w-full bg-n-8 mb-2 px-4 py-2 border rounded-lg"
            />
            <div className="flex justify-end gap-4">
              <button
                onClick={() => setIsEditModalOpen(null)}
                className="px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-700"
              >
                {t("environment.cancel")}
              </button>
              <button
                onClick={() => {
                  setIsUpdating(true);
                  handleUpdateEnvironment(isEditModalOpen).finally(() =>
                    setIsUpdating(false)
                  );
                }}
                className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
                disabled={isUpdating}
              >
                {isUpdating ? (
                  <FaSpinner className="animate-spin" />
                ) : (
                  t("environment.update")
                )}
              </button>
            </div>
          </div>
        </div>
      )}

      {isDeleteModalOpen && (
        <div className="fixed top-0 left-0 w-full h-full bg-n-8 bg-opacity-50 flex items-center justify-center">
          <div className="bg-n-6 p-6 rounded-lg shadow-lg">
            <h3 className="text-lg font-bold mb-4">
              {t("environment.confirm_delete")}
            </h3>
            <p className="mb-4 text-sm text-n-3">
              {t("environment.confirm_delete_message", {
                name: environments.find((env) => env.id === isDeleteModalOpen)
                  ?.name,
              })}
            </p>
            <input
              type="text"
              value={deleteInput}
              onChange={(e) => setDeleteInput(e.target.value)}
              className="w-full mb-4 px-4 py-2 border rounded-lg"
            />
            <div className="flex justify-end gap-4">
              <button
                onClick={() => setIsDeleteModalOpen(null)}
                className="px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-700"
              >
                {t("environment.cancel")}
              </button>
              <button
                onClick={() => {
                  setIsDeleting(true);
                  handleDeleteEnvironment(isDeleteModalOpen).finally(() =>
                    setIsDeleting(false)
                  );
                }}
                className={`px-4 py-2 bg-red-600 text-white rounded-md ${
                  deleteInput ===
                  environments.find((env) => env.id === isDeleteModalOpen)?.name
                    ? "hover:bg-red-700"
                    : "opacity-50 cursor-not-allowed"
                }`}
                disabled={
                  isDeleting ||
                  deleteInput !==
                    environments.find((env) => env.id === isDeleteModalOpen)
                      ?.name
                }
              >
                {isDeleting ? (
                  <FaSpinner className="animate-spin" />
                ) : (
                  t("environment.delete")
                )}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default EnvironmentInfo;
