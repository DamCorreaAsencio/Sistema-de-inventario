import React, { useState, useEffect } from "react";
import axios from "axios";
import Swal from "sweetalert2";
import { API_ROUTES } from "../api/apiRoutes";

const Soportes = ({ usuario }) => {
  const [mantenimientos, setMantenimientos] = useState([]);
  const [totalRegistros, setTotalRegistros] = useState(0);

  const [modalVisible, setModalVisible] = useState(false);
  const [selectedFalla, setSelectedFalla] = useState("");
  const [selectedNumSerie, setSelectedNumSerie] = useState("");
  const [selectedIdHistorial, setSelectedIdHistorial] = useState("");
  const [solucion, setSolucion] = useState("");

  // Cargar mantenimientos pendientes
  const fetchMantenimientos = async () => {
    try {
      const { data } = await axios.get(API_ROUTES.OBTENER_MANTENIMIENTOS);
      setMantenimientos(data);
      setTotalRegistros(data.length);
    } catch (err) {
      Swal.fire({
        icon: "error",
        title: "Error",
        text: "No se pudieron obtener los datos",
        confirmButtonText: "Ok",
      });
    }
  };

  useEffect(() => {
    fetchMantenimientos();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Abrir modal
  const handleOpenModal = (falla, idHistorial, num_serie) => {
    setSelectedFalla(falla);
    setSelectedIdHistorial(idHistorial);
    setSelectedNumSerie(num_serie);
    setModalVisible(true);
  };

  // Cerrar modal
  const handleCloseModal = () => {
    setModalVisible(false);
    setSolucion("");
  };

  // Registrar solución
  const registrarSolucion = async (e) => {
    e.preventDefault();

    if (!solucion.trim()) {
      Swal.fire({
        icon: "error",
        title: "Error",
        text: "Por favor, ingresa la solución",
        confirmButtonText: "Ok",
      });
      return;
    }

    // usuario es un objeto { usuario, nombre, area, estado }
    const tecnico = usuario?.usuario; // enviar solo el username

    if (!selectedNumSerie || !selectedIdHistorial || !tecnico) {
      Swal.fire({
        icon: "error",
        title: "Error",
        text: "Faltan datos requeridos",
        confirmButtonText: "Ok",
      });
      return;
    }

    try {
      const { data } = await axios.post(API_ROUTES.ACTUALIZAR_MANTENIMIENTOS, {
        num_serie: selectedNumSerie,
        id_historial: selectedIdHistorial,
        tecnico,            // string (username)
        solucion: solucion,
      });

      Swal.fire({
        icon: "success",
        title: "Éxito",
        text: data,
        confirmButtonText: "Ok",
      });

      handleCloseModal();
      fetchMantenimientos();
    } catch (err) {
      Swal.fire({
        icon: "error",
        title: "Error",
        text:
          err.response?.data ||
          "No se pudo registrar la solución, intenta nuevamente.",
        confirmButtonText: "Ok",
      });
    }
  };

  return (
    <div className="container mt-4">
      <h5 className="text-center mb-4">
        Mantenimientos Pendientes: {totalRegistros}
      </h5>

      <table className="table table-bordered table-striped">
        <thead>
          <tr className="text-center" style={{ textTransform: "uppercase" }}>
            <th>ID HISTORIAL</th>
            <th>NÚMERO SERIE</th>
            <th>FECHA REPORTE</th>
            <th>DESCRIPCIÓN FALLA</th>
            <th>ACCIONES</th>
          </tr>
        </thead>

        <tbody>
          {mantenimientos.map((equipo, index) => (
            <tr key={index}>
              <td>{equipo.id_historial}</td>
              <td>{equipo.num_serie}</td>
              <td>{String(equipo.fecha_reporte).slice(0, 10)}</td>
              <td>{equipo.falla}</td>
              <td className="text-center">
                <button
                  className="btn btn-warning btn-sm me-2"
                  onClick={() =>
                    handleOpenModal(
                      equipo.falla,
                      equipo.id_historial, // corregido
                      equipo.num_serie
                    )
                  }
                  title="Registrar solución"
                >
                  <i className="bi bi-pencil-square"></i> {/* className */}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {modalVisible && (
        <div className="modal fade show" tabIndex="-1" style={{ display: "block" }}>
          <div className="modal-dialog modal-dialog-centered">
            <div className="modal-content">
              <div className="modal-header">
                <h5 className="modal-title">Registrar solución</h5>
                <button type="button" className="btn-close" onClick={handleCloseModal}></button>
              </div>

              <div className="modal-body">
                <p>
                  <strong>Falla: </strong> {selectedFalla}
                </p>
                <p>
                  <strong>Número de Serie: </strong> {selectedNumSerie}
                </p>
                <p>
                  <strong>Técnico: </strong> {usuario?.nombre || usuario?.usuario}
                </p>

                <form onSubmit={registrarSolucion}>
                  <div className="mb-3">
                    <label htmlFor="solucion" className="form-label">
                      Solución
                    </label>
                    <textarea
                      className="form-control"
                      id="solucion"
                      value={solucion}
                      onChange={(e) => setSolucion(e.target.value)}
                      required
                    ></textarea>
                  </div>

                  <div className="text-center">
                    <button className="btn btn-primary" type="submit">
                      Registrar solución
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Soportes