import React, { useState, useEffect } from "react";
import axios from "axios";
import Swal from "sweetalert2";
import { API_ROUTES } from "../api/apiRoutes";

const Equipos = () => {
  const [equipos, setEquipos] = useState([]);
  const [filteredEquipos, setFilteredEquipos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [modalEquipo, setModalEquipo] = useState(false);
  const [equipoSeleccionado, setEquipoSeleccionado] = useState({});

  const [modalAsignacion, setModalAsignacion] = useState(false);
  const [usuario, setUsuario] = useState("");

  const [filter, setFilter] = useState("");

  // Cargar equipos
  useEffect(() => {
    axios
      .get(API_ROUTES.EQUIPOS)
      .then((response) => {
        setEquipos(response.data);
        setFilteredEquipos(response.data);
        setLoading(false);
      })
      .catch((err) => {
        setError("Hubo un error al obtener los equipos");
        setLoading(false);
      });
  }, []);

  if (loading) return <div className="text-center">Cargando...</div>;
  if (error) return <div className="text-center text-danger">{error}</div>;

  // Filtrar por num_serie o responsable
  const handleFilterChange = (e) => {
    const value = e.target.value;
    setFilter(value);

    const filtered = equipos.filter(
      (eq) =>
        String(eq.num_serie).toLowerCase().includes(value.toLowerCase()) ||
        String(eq.responsable || "").toLowerCase().includes(value.toLowerCase())
    );
    setFilteredEquipos(filtered);
  };

  // Abrir modal asignación
  const asignarUsuario = (equipo) => {
    setEquipoSeleccionado({ ...equipo });
    setUsuario(equipo.responsable || "");
    setModalAsignacion(true); // corregido nombre del setter
  };

  const handleUsuarioChange = (e) => setUsuario(e.target.value);

  // POST asignar responsable
  const asignarResponsable = () => {
    const { num_serie } = equipoSeleccionado;

    axios
      .post(API_ROUTES.ASIGNAR_USUARIO, {
        num_serie,
        usuario,
      })
      .then((response) => {
        const updateEquipos = equipos.map((eq) =>
          eq.num_serie === num_serie ? { ...eq, responsable: usuario } : eq
        );
        setEquipos(updateEquipos);
        // mantener filtro aplicado
        setFilteredEquipos(
          filter
            ? updateEquipos.filter(
                (eq) =>
                  String(eq.num_serie)
                    .toLowerCase()
                    .includes(filter.toLowerCase()) ||
                  String(eq.responsable || "")
                    .toLowerCase()
                    .includes(filter.toLowerCase())
              )
            : updateEquipos
        );
        setModalAsignacion(false);

        Swal.fire({
          icon: "success", // corregido
          title: "Usuario asignado",
          text:
            typeof response.data === "string"
              ? response.data
              : "Se asignó exitosamente el usuario.",
          timer: 1500,
          showConfirmButton: false,
        });
      })
      .catch((err) =>
        Swal.fire({
          icon: "error",
          title: "Error al asignar usuario",
          text: err.response?.data || "Hubo un error al asignar el usuario.",
        })
      );
  };

  // Colorear estado
  const getEstadoClass = (estado) => {
    switch (String(estado).toLowerCase()) {
      case "baja":
        return "bg-danger text-white";
      case "activo":
        return "bg-success text-white";
      case "mantenimiento":
        return "bg-warning text-dark";
      case "reservado":
        return "bg-secondary text-white";
      default:
        return "";
    }
  };

  // Abrir modal reporte de falla
  const editarEquipo = (equipo) => {
    setEquipoSeleccionado({ ...equipo });
    setModalEquipo(true);
  };

  // Cambios en formulario de reporte
  const handleChange = (e) => {
    const { name, value } = e.target;
    setEquipoSeleccionado((prev) => ({ ...prev, [name]: value }));
  };

  // POST reporte de falla
  const guardarReporteFalla = () => {
    const reporte = {
      num_serie: equipoSeleccionado.num_serie,
      falla: equipoSeleccionado.falla,
    };

    if (!reporte.falla || !reporte.num_serie) {
      Swal.fire({
        icon: "error",
        title: "Campos incompletos",
        text: "Completa todos los campos antes de enviar el reporte.",
      });
      return;
    }

    axios
      .post(API_ROUTES.REPORTE_FALLA, reporte)
      .then((response) => {
        // Actualizar estado del equipo reportado a mantenimiento
        const updated = equipos.map((eq) =>
          eq.num_serie === equipoSeleccionado.num_serie
            ? { ...eq, estado: "mantenimiento" }
            : eq
        );
        setEquipos(updated);
        setFilteredEquipos(
          filter
            ? updated.filter(
                (eq) =>
                  String(eq.num_serie)
                    .toLowerCase()
                    .includes(filter.toLowerCase()) ||
                  String(eq.responsable || "")
                    .toLowerCase()
                    .includes(filter.toLowerCase())
              )
            : updated
        );

        setModalEquipo(false);
        Swal.fire({
          icon: "success",
          title: "Reporte enviado",
          text:
            typeof response.data === "string"
              ? response.data
              : "Se envió el reporte de falla.",
          showConfirmButton: false,
          timer: 1500,
        });
      })
      .catch((err) =>
        Swal.fire({
          icon: "error",
          title: "Error al enviar reporte",
          text: err.response?.data || "No se pudo enviar el reporte.",
        })
      );
  };

  return (
    <div className="container mt-4">
      <h5 className="text-center mb-4">Listado de Equipos</h5>

      {/* Filtro */}
      <div className="d-flex justify-content-start mb-3">
        <input
          type="text"
          className="form-control"
          placeholder="Filtrar por número de serie o responsable"
          value={filter}
          onChange={handleFilterChange}
        />
      </div>

      <table className="table table-bordered table-striped">
        <thead>
          <tr className="text-center" style={{ textTransform: "uppercase" }}>
            <th>NÚMERO SERIE</th>
            <th>EQUIPO</th>
            <th>RESPONSABLE</th>
            <th>ÁREA</th>
            <th>ESTADO</th>
            <th>ACCIONES</th>
          </tr>
        </thead>

        <tbody>
          {filteredEquipos.map((eq, index) => (
            <tr key={index}>
              <td>{eq.num_serie}</td>
              <td>{eq.equipo}</td>
              <td>{eq.responsable || "-"}</td>
              <td>{eq.area}</td>
              <td className={`text-center ${getEstadoClass(eq.estado)}`}>
                {eq.estado}
              </td>
              <td className="text-center">
                <button
                  className="btn btn-primary btn-sm me-2"
                  onClick={() => asignarUsuario(eq)}
                  title="Asignar usuario"
                >
                  <i className="bi bi-person-plus"></i>
                </button>

                <button
                  className="btn btn-warning btn-sm me-2"
                  onClick={() => editarEquipo(eq)} // corregido
                  title="Reportar falla"
                >
                  <i className="bi bi-pencil-square"></i>
                </button>
              </td>
            </tr>
          ))}

          {filteredEquipos.length === 0 && (
            <tr>
              <td colSpan="6" className="text-center">
                No hay equipos para mostrar.
              </td>
            </tr>
          )}
        </tbody>
      </table>

      {/* Modal Asignación */}
      {modalAsignacion && (
        <div
          className="modal fade show d-block"
          role="dialog"
          tabIndex="-1"
          style={{ display: "block", zIndex: "1050" }}
          onClick={() => setModalAsignacion(false)}
        >
          <div
            className="modal-dialog modal-dialog-centered"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="modal-content">
              <div className="modal-header">
                <h5 className="modal-title">Asignar usuario</h5>
                <button
                  type="button"
                  className="btn-close"
                  onClick={() => setModalAsignacion(false)}
                />
              </div>

              <div className="modal-body">
                <form>
                  <div className="form-group mb-3">
                    <label>Número de serie</label>
                    <input
                      type="text"
                      className="form-control"
                      name="num_serie"
                      value={equipoSeleccionado.num_serie || ""}
                      disabled
                    />
                  </div>

                  <div className="form-group mb-3">
                    <label>Usuario</label>
                    <input
                      type="text"
                      className="form-control"
                      name="usuario"
                      value={usuario}
                      onChange={handleUsuarioChange}
                    />
                  </div>
                </form>
              </div>

              <div className="modal-footer">
                <button
                  type="button"
                  className="btn btn-secondary"
                  onClick={() => setModalAsignacion(false)}
                >
                  Cancelar
                </button>

                <button
                  type="button"
                  className="btn btn-primary"
                  onClick={asignarResponsable}
                >
                  Asignar usuario
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Modal Reporte Falla */}
      {modalEquipo && (
        <div
          className="modal fade show d-block"
          role="dialog"
          tabIndex="-1"
          style={{ display: "block", zIndex: "1050" }}
          onClick={() => setModalEquipo(false)}
        >
          <div
            className="modal-dialog modal-dialog-centered"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="modal-content">
              <div className="modal-header">
                <h5 className="modal-title">Nuevo reporte de falla</h5>
                <button
                  type="button"
                  className="btn-close"
                  onClick={() => setModalEquipo(false)}
                />
              </div>

              <div className="modal-body">
                <form>
                  <div className="form-group mb-3">
                    <label>Número de serie</label>
                    <input
                      type="text"
                      className="form-control"
                      name="num_serie"
                      value={equipoSeleccionado.num_serie || ""}
                      onChange={handleChange}
                      disabled
                    />
                  </div>

                  <div className="form-group mb-3">
                    <label>Falla del equipo</label>
                    <textarea
                      className="form-control"
                      name="falla"
                      value={equipoSeleccionado.falla || ""}
                      onChange={handleChange}
                      rows="3"
                    />
                  </div>
                </form>
              </div>

              <div className="modal-footer">
                <button
                  type="button"
                  className="btn btn-secondary"
                  onClick={() => setModalEquipo(false)}
                >
                  Cancelar
                </button>

                <button
                  type="button"
                  className="btn btn-primary"
                  onClick={guardarReporteFalla}
                >
                  Enviar reporte
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Equipos;