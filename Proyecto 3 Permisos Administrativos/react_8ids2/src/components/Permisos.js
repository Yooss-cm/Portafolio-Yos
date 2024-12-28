import React, { useEffect, useState } from 'react';
import Menu from "./Menu";
import { Button, Col, Container, Row, Table} from 'react-bootstrap';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faPlus } from '@fortawesome/free-solid-svg-icons';
import "./../styles/permisos.css";
import { Link } from "react-router-dom";
import { useNavigate, useSearchParams } from 'react-router-dom';
import axios from 'axios';
import Swal from 'sweetalert2';
  
    const Permisos = () => {
      const [permisos, setPermisos] = useState([]);
      const [token, setToken] = useState('');
      const [id_usuario, setIdUsuario] = useState(0);
      const navigate = useNavigate();

        

        const fetchData = async ()=>{

            try{
                const response = await axios.get('http://127.0.0.1:8000/api/permisos?id_usuario=' + id_usuario,{
                    headers: {
                        Authorization: 'Bearer ' + token,

                    },
                })
                console.log(response.data)
                setPermisos(response.data);
            } catch(error){
                console.log("Ocurrio un error" + error);
            }
        };
        
        const deleteRecord = async (id) => {
          Swal.fire({
              title: "¿Estas seguro?",
              text: "No podrás revertir los cambios!",
              icon: "warning",
              showCancelButton: true,
              confirmButtonColor: "#3085d6",
              cancelButtonColor: "#d33",
              confirmButtonText: "Si, deseo eliminar"
          }).then(async (result) => {
              if (result.isConfirmed) {
                  try {
                      const response = await axios.post('http://127.0.0.1:8000/api/permiso/borrar', {
                          'id': id
                      }, {
                          headers: {
                              Authorization: 'Bearer ' + token,
                          },
                      });
                      fetchData();
                      Swal.fire({
                          title: "Eliminado!",
                          text: "El registro se eliminó.",
                          icon: "success"
                      });
                  } catch (error) {
                      console.log("Ocurrio un error" + error);
                  }
              }
          });
      };
    
        useEffect(()=> {
            const storedToken =localStorage.getItem('token')
            setIdUsuario(localStorage.getItem('id_usuario'))
            setToken(storedToken)
        }, []);

        useEffect(()=> {
            if (token){
            fetchData();
            }
        }, [token]);

        
        return (
            <div class="container mt-5">
              <Menu />
              <Container className="mt-4">
                <Row striped="columns">
                  <Col>
                    <center><h2>REGISTROS</h2></center>
                    <Table striped bordered hover variant="secondary">
                      <thead>
                      <tr>
                    <th>Profesor</th>
                    <th>Fecha</th>
                    <th>Motivo</th>
                    <th>Estado</th>
                    <th>Observaciones</th>
                    <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    {permisos.map(permiso => (
                    <tr key={permiso.id}>
                        <td>{permiso.nombre_profesor}</td>
                        <td>{permiso.fecha}</td>
                        <td>{permiso.motivo}</td>
                        <td>{permiso.estado}</td>
                        <td>{permiso.observaciones}</td>
                        <td>
                        {permiso.estado === 'P' && (
                          <>
                            <button class="btn-neon2" type="submit" onClick={() => navigate('/permiso/nuevo/' + permiso.id)}>
                                <span id="span1"></span>
                                <span id="span2"></span>
                                <span id="span3"></span>
                                <span id="span4"></span>
                                Editar</button>
                                {'   '}{'   '}
                              <button class="btn-neon" type="submit" onClick={() => deleteRecord(permiso.id) }>
                                <span id="span1"></span>
                                <span id="span2"></span>
                                <span id="span3"></span>
                                <span id="span4"></span>
                                Eliminar</button>
                            {/* <Button variant="outline-success" onClick={() => navigate('/permiso/nuevo/' + permiso.id)}>Editar</Button>
                            {'   '}
                            <Button variant="outline-danger" onClick={() => deleteRecord(permiso.id)}>Eliminar</Button> */}
                            </>
                        )}
                        </td>
                    </tr>
                        ))}
                      </tbody>
                    </Table>
                  </Col>
                </Row>
              </Container>
              <div className="floating-button">
                <Link to="/permiso/nuevo">
                  <Button variant="dark">
                    <FontAwesomeIcon icon={faPlus} />
                  </Button>
                </Link>
              </div>
            </div>
          );
        };


export default Permisos;
        
            