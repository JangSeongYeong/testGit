package kr.ajax.board.dao;

import java.util.List;

import kr.ajax.board.dto.BoardDTO;

public interface BoardDAO {

	List<BoardDTO> list();

	List<String> getFiles(String idx);

	int del(String idx);

	
}
