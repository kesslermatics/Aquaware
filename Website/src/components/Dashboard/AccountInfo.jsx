import React, { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import Cookies from "js-cookie";

const EnvironmentInfo = () => {
  const { t } = useTranslation();
  const [environments, setEnvironments] = useState([]);
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [isEditModalOpen, setIsEditModalOpen] = useState(null); // Track the ID of the environment being edited
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(null); // Track the ID of the environment being deleted
  const [formData, setFormData] = useState({
    name: "",
    description: "",
    environment_type: "aquarium",
    public: false,
    city: "",
  });

  const ensureAccessToken = async () => {
    const accessToken = Cookies.get("access_token");
    const refreshToken = Cookies.get("refresh_token");

    if (!accessToken && refreshToken) {
      await refreshAccessToken(refreshToken);
    }
  };

  const refreshAccessToken = async (refreshToken) => {
    try {
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/auth/token/refresh/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ refresh: refreshToken }),
          credentials: "include",
        }
      );

      if (response.ok) {
        const data = await response.json();
        Cookies.set("access_token", data.access);
        return true;
      } else {
        throw new Error(t("environment.tokenRefreshError"));
      }
    } catch (error) {
      throw error;
    }
  };

  const fetchEnvironments = async () => {
    try {
      await ensureAccessToken();
      const accessToken = Cookies.get("access_token");

      const response = await fetch(
        "https://dev.aquaware.cloud/api/environments/",
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${accessToken}`,
          },
        }
      );

      if (response.ok) {
        const data = await response.json();
        setEnvironments(data);
      } else {
        throw new Error(t("environment.fetchError"));
      }
    } catch (error) {
      console.error("Error fetching environments:", error);
    }
  };

  const handleCreateEnvironment = async () => {
    try {
      await ensureAccessToken();
      const accessToken = Cookies.get("access_token");

      const response = await fetch(
        "https://dev.aquaware.cloud/api/environments/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${accessToken}`,
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
      await ensureAccessToken();
      const accessToken = Cookies.get("access_token");

      const response = await fetch(
        `https://dev.aquaware.cloud/api/environments/${id}/`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${accessToken}`,
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
      await ensureAccessToken();
      const accessToken = Cookies.get("access_token");

      const response = await fetch(
        `https://dev.aquaware.cloud/api/environments/${id}/`,
        {
          method: "DELETE",
          headers: {
            Authorization: `Bearer ${accessToken}`,
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

  return (
    <div>
      <button onClick={() => setIsCreateModalOpen(true)}>
        {t("create_new_environment")}
      </button>

      {isCreateModalOpen && (
        <div className="modal">
          <h3>{t("environment.create_environment")}</h3>
          <input
            type="text"
            placeholder={t("environment.name")}
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          />
          <textarea
            placeholder={t("environment.description")}
            value={formData.description}
            onChange={(e) =>
              setFormData({ ...formData, description: e.target.value })
            }
          />
          <select
            value={formData.environment_type}
            onChange={(e) =>
              setFormData({ ...formData, environment_type: e.target.value })
            }
          >
            <option value="aquarium">{t("environment.aquarium")}</option>
            <option value="lake">{t("environment.lake")}</option>
            <option value="sea">{t("environment.sea")}</option>
            <option value="pool">{t("environment.pool")}</option>
            <option value="other">{t("environment.other")}</option>
          </select>
          <input
            type="checkbox"
            checked={formData.public}
            onChange={(e) =>
              setFormData({ ...formData, public: e.target.checked })
            }
          />
          {t("environment.make_public")}
          <input
            type="text"
            placeholder={t("environment.city")}
            value={formData.city}
            onChange={(e) => setFormData({ ...formData, city: e.target.value })}
          />
          <button onClick={handleCreateEnvironment}>
            {t("environment.create")}
          </button>
          <button onClick={() => setIsCreateModalOpen(false)}>
            {t("environment.cancel")}
          </button>
        </div>
      )}

      {Array.isArray(environments) &&
        environments.map((env) => (
          <div key={env.id} className="card">
            <h3>
              {renderIcon(env.environment_type)} {env.id}
            </h3>
            <p>{env.name}</p>
            <p>{env.description}</p>
            <p>{env.city}</p>
            <button onClick={() => setIsEditModalOpen(env.id)}>
              {t("environment.edit")}
            </button>
            <button onClick={() => setIsDeleteModalOpen(env.id)}>
              {t("environment.delete")}
            </button>
          </div>
        ))}
    </div>
  );
};

export default EnvironmentInfo;
