abstract class IUseCaseEntity<Entity, DTO> {
  Entity fromDTO(DTO dto);
  DTO toDTO();
}
