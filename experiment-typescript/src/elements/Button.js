import styled from 'styled-components';

export default styled.button`
  height: 34px;
  padding: 0px 12px 4px 12px;
  border-radius: 4px;
  font-family: GTAmericaMonoMedium, monospace;
  cursor: pointer;
  &:disabled,
  &[disabled] {
    cursor: default;
    border-color: #CED8E1;
    color: #CED8E1;
  }
`;
