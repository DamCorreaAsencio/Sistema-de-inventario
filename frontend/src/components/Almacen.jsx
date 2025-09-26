import React, { useState, useEffect } from "react";
import axios from "axios";
import Swal from "sweetalert2";
import { API_ROUTES } from "../api/apiRoutes";

const Almacen = () => {
  const [productos, setProductos] = useState([]);
  const [filteredProductos, setFilteredProductos] = useState([]);

  const [modalProducto, setModalProducto] = useState(false);
  const [prodSeleccionado, setProdSeleccionado] = useState({
    codigo: "",
    nom_producto: "",
    desc_producto: "",
    pre_publico: "",
    pre_proveedor: "",
    existencias: "",
    isEditing: false,
  });

  const [filter, setFilter] = useState("");

  // Cargar productos
  useEffect(() => {
    const fetchProductos = async () => {
      try {
        const { data } = await axios.get(API_ROUTES.OBTENER_PRODUCTOS);
        setProductos(data);
        setFilteredProductos(data); // 👈 importante
      } catch (err) {
        Swal.fire({
          icon: "error",
          title: "Error",
          text: "No se pudieron obtener los productos",
        });
      }
    };
    fetchProductos();
  }, []);

  // Filtrar por código o nombre
  const handleFilterChange = (e) => {
    const value = e.target.value;
    setFilter(value);

    if (!value.trim()) {
      setFilteredProductos(productos);
      return;
    }

    const filtered = productos.filter(
      (p) =>
        p.codigo.toLowerCase().includes(value.toLowerCase()) ||
        p.nom_producto.toLowerCase().includes(value.toLowerCase())
    );
    setFilteredProductos(filtered);
  };

  // Abrir modal de nuevo producto
  const nuevoProducto = () => {
    setProdSeleccionado({
      codigo: "",
      nom_producto: "",
      desc_producto: "",
      pre_publico: "",
      pre_proveedor: "",
      existencias: "",
      isEditing: false,
    });
    setModalProducto(true);
  };

  // Cambios de formulario
  const handleChange = (e) => {
    const { name, value } = e.target;
    setProdSeleccionado((prev) => ({ ...prev, [name]: value }));
  };

  // Guardar (crear/actualizar)
  const guardarProducto = async () => {
    try {
      // Normalizar tipos numéricos
      const payload = {
        ...prodSeleccionado,
        pre_publico: parseFloat(prodSeleccionado.pre_publico),
        pre_proveedor: parseFloat(prodSeleccionado.pre_proveedor),
        existencias: parseInt(prodSeleccionado.existencias, 10),
      };

      if (Number.isNaN(payload.pre_publico) || Number.isNaN(payload.pre_proveedor) || Number.isNaN(payload.existencias)) {
        Swal.fire({ icon: "error", title: "Datos inválidos", text: "Revisa precios y existencias (numéricos)." });
        return;
      }

      if (prodSeleccionado.isEditing) {
        // PUT: backend devuelve un string, no un objeto
        await axios.put(API_ROUTES.ACTUALIZAR_PRODUCTO(prodSeleccionado.codigo), {
          nom_producto: payload.nom_producto,
          desc_producto: payload.desc_producto,
          pre_publico: payload.pre_publico,
          pre_proveedor: payload.pre_proveedor,
          existencias: payload.existencias,
        });

        // Actualizar lista local
        const updated = productos.map((p) =>
          p.codigo === prodSeleccionado.codigo ? { ...p, ...payload } : p
        );
        setProductos(updated);
        setFilteredProductos(
          filter.trim()
            ? updated.filter(
                (p) =>
                  p.codigo.toLowerCase().includes(filter.toLowerCase()) ||
                  p.nom_producto.toLowerCase().includes(filter.toLowerCase())
              )
            : updated
        );

        setModalProducto(false);
        Swal.fire({
          icon: "success",
          title: "Producto actualizado correctamente",
          showConfirmButton: false,
          timer: 1500,
        });
      } else {
        // POST: backend devuelve el objeto creado
        const { data } = await axios.post(API_ROUTES.CREAR_PRODUCTO, payload);
        const newList = [...productos, data];
        setProductos(newList);
        setFilteredProductos(
          filter.trim()
            ? newList.filter(
                (p) =>
                  p.codigo.toLowerCase().includes(filter.toLowerCase()) ||
                  p.nom_producto.toLowerCase().includes(filter.toLowerCase())
              )
            : newList
        );

        setModalProducto(false);
        Swal.fire({
          icon: "success",
          title: "Producto creado correctamente",
          showConfirmButton: false,
          timer: 1500,
        });
      }
    } catch (err) {
      Swal.fire({
        icon: "error",
        title: prodSeleccionado.isEditing ? "Error al actualizar" : "Error al crear",
        text:
          err.response?.data ||
          "Hubo un problema al guardar el producto. Inténtalo nuevamente.",
      });
    }
  };

  // Editar producto
  const editarProducto = (producto) => {
    setProdSeleccionado({
      ...producto,
      isEditing: true,
    });
    setModalProducto(true);
  };

  // Borrar producto
  const borrarProducto = (producto) => {
    Swal.fire({
      icon: "warning",
      title: "¿Estás seguro?",
      text: `Eliminarás el producto: ${producto.codigo} - ${producto.nom_producto}`,
      showCancelButton: true,
      confirmButtonText: "Sí, eliminar",
      cancelButtonText: "Cancelar",
    }).then(async (result) => {
      if (!result.isConfirmed) return;

      try {
        await axios.delete(API_ROUTES.ELIMINAR_PRODUCTO(producto.codigo));
        const remaining = productos.filter((p) => p.codigo !== producto.codigo);
        setProductos(remaining);
        setFilteredProductos(
          filter.trim()
            ? remaining.filter(
                (p) =>
                  p.codigo.toLowerCase().includes(filter.toLowerCase()) ||
                  p.nom_producto.toLowerCase().includes(filter.toLowerCase())
              )
            : remaining
        );

        Swal.fire({
          icon: "success",
          title: "Producto eliminado",
          showConfirmButton: false,
          timer: 1500,
        });
      } catch (err) {
        Swal.fire({
          icon: "error",
          title: "Error al eliminar el producto",
          text: err.response?.data || "No se pudo eliminar el producto",
        });
      }
    });
  };

  // Colorear existencias
  const getEstadoExistenciasClass = (existencias) => {
    if (existencias <= 10) return "bg-danger text-white";
    if (existencias <= 15) return "bg-warning text-dark";
    return "bg-success text-white";
  };

  return (
    <div className="container mt-4">
      <h3 className="text-center mb-4">Listado de productos</h3>

      {/* Filtro */}
      <div className="d-flex justify-content-start mb-3">
        <input
          type="text"
          className="form-control"
          placeholder="Filtrar por código o nombre"
          value={filter}
          onChange={handleFilterChange}
        />
      </div>

      {/* Nuevo producto */}
      <div className="d-flex justify-content-end mb-3">
        <button className="btn btn-primary" onClick={nuevoProducto}>
          <i className="bi bi-plus-circle"></i> Nuevo producto
        </button>
      </div>

      <table className="table table-bordered table-striped">
        <thead>
          <tr className="text-center" style={{ textTransform: "uppercase" }}>
            <th>Código</th>
            <th>Producto</th>
            <th>Descripción</th>
            <th>Precio Público</th>
            <th>Precio Proveedor</th>
            <th>Existencias</th>
            <th>Acciones</th>
          </tr>
        </thead>

        <tbody>
          {filteredProductos.map((producto, index) => (
            <tr key={index}>
              <td>{producto.codigo}</td>
              <td>{producto.nom_producto}</td>
              <td>{producto.desc_producto}</td>
              <td>{producto.pre_publico}</td>
              <td>{producto.pre_proveedor}</td>
              <td className={`text-center ${getEstadoExistenciasClass(producto.existencias)}`}>
                {producto.existencias}
              </td>
              <td className="text-center">
                <button
                  className="btn btn-warning btn-sm me-2"
                  onClick={() => editarProducto(producto)}
                  title="Editar"
                >
                  <i className="bi bi-pencil-square"></i>
                </button>

                <button
                  className="btn btn-danger btn-sm"
                  onClick={() => borrarProducto(producto)}
                  title="Eliminar"
                >
                  <i className="bi bi-trash"></i>
                </button>
              </td>
            </tr>
          ))}

          {filteredProductos.length === 0 && (
            <tr>
              <td colSpan="7" className="text-center">
                No hay productos para mostrar.
              </td>
            </tr>
          )}
        </tbody>
      </table>

      {/* Modal */}
      {modalProducto && (
        <div className="modal show" style={{ display: "block" }} onClick={() => setModalProducto(false)}>
          <div className="modal-dialog" onClick={(e) => e.stopPropagation()}>
            <div className="modal-content">
              <div className="modal-header">
                <h5 className="modal-title">
                  {prodSeleccionado.isEditing ? "Editar producto" : "Nuevo producto"}
                </h5>
                <button type="button" className="btn-close" onClick={() => setModalProducto(false)}></button>
              </div>

              <div className="modal-body">
                <form>
                  <div className="form-group mb-3">
                    <label>Código</label>
                    <input
                      type="text"
                      className="form-control"
                      name="codigo"
                      value={prodSeleccionado.codigo}
                      onChange={handleChange}
                      disabled={prodSeleccionado.isEditing}
                    />
                  </div>

                  <div className="form-group mb-3">
                    <label>Producto</label>
                    <input
                      type="text"
                      className="form-control"
                      name="nom_producto"
                      value={prodSeleccionado.nom_producto}
                      onChange={handleChange}
                    />
                  </div>

                  <div className="form-group mb-3">
                    <label htmlFor="desc_producto" className="form-label">Descripción</label>
                    <textarea
                      name="desc_producto"
                      id="desc_producto"
                      className="form-control"
                      value={prodSeleccionado.desc_producto}
                      onChange={handleChange}
                    ></textarea>
                  </div>

                  <div className="form-group mb-3">
                    <label>Precio público</label>
                    <input
                      type="number"
                      step="0.01"
                      className="form-control"
                      name="pre_publico"
                      value={prodSeleccionado.pre_publico}
                      onChange={handleChange}
                    />
                  </div>

                  <div className="form-group mb-3">
                    <label>Precio proveedor</label>
                    <input
                      type="number"
                      step="0.01"
                      className="form-control"
                      name="pre_proveedor"
                      value={prodSeleccionado.pre_proveedor}
                      onChange={handleChange}
                    />
                  </div>

                  <div className="form-group mb-3">
                    <label>Existencias</label>
                    <input
                      type="number"
                      className="form-control"
                      name="existencias"
                      value={prodSeleccionado.existencias}
                      onChange={handleChange}
                    />
                  </div>
                </form>
              </div>

              <div className="modal-footer">
                <button type="button" className="btn btn-secondary" onClick={() => setModalProducto(false)}>
                  Cancelar
                </button>
                <button type="button" className="btn btn-primary" onClick={guardarProducto}>
                  {prodSeleccionado.isEditing ? "Guardar cambios" : "Guardar producto"}
                </button>
              </div>

            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Almacen;