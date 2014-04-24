unit GameModules;

interface

uses
	Windows, Classes, SysUtils, Graphics, ExtCtrls, Forms;

type
	TTileArray	= array[0..15] of Integer;
	PTileArray	= ^TTileArray;

	TTileMatrix	= array[0..3, 0..3] of Integer;
	PTileMatrix	= ^TTileMatrix;

	TMoveAspect	= ( maLeft, maRight, maUp, maDown );

	TGameView	= class
	private
		FCanvas	: TCanvas;
		FMapSize, FMapRound, FTileSize, FTileRound,
		FBaseTileOff, FFullTileSize	: Integer;
		FBackgroundColor	: TColor;
		FFontSize	: array[0..15] of Integer;
		procedure SetMapSize(const Value: Integer);
	public
		constructor Create(ACanvas: TCanvas; AMapSize: Integer);

		procedure DrawBackground;
		procedure	DrawRoundRectAt(X, Y: Integer; Size, Round: Integer; Color: TColor);
		procedure DrawTileAtPoint(X, Y: Integer; Index: Integer);
		procedure	DrawTileTextAt(X, Y: Integer; Size: Integer; Color: TColor; const Text: string);
		procedure ShowTile(Row, Col: Integer; Index: Integer);
    procedure DrawTiles(const Tiles: TTileMatrix);

		property BackgroundColor: TColor read FBackgroundColor write FBackgroundColor;
		property MapSize: Integer read FMapSize write SetMapSize;
	public
		procedure AnimateNewTile(Row, Col: Integer; Index: Integer);
		procedure AnimateMoveMerge(const Src, Dst: TTileMatrix; Aspect: TMoveAspect);
	end;

	TGameModel = class
	private
		FScore	: Integer;
		FTiles	: TTileMatrix;
		PTiles	: PTileArray;
    function GetCanMove: Boolean;
    function GetTileArray(Index: Integer): Integer;
    function GetTileMatrix(Row, Col: Integer): Integer;
    procedure SetTileArray(Index: Integer; const Value: Integer);
    procedure SetTileMatrix(Row, Col: Integer; const Value: Integer);
	public
	  constructor Create; virtual;
		procedure RestartGame;
		function GenerateRandomTile: Integer;
		function MoveTiles(Aspect: TMoveAspect; out ScoreToAdd: Integer): Boolean;

		property Score: Integer read FScore write FScore;
		property CanMove: Boolean read GetCanMove;
		property TileMatrix[Row, Col: Integer]: Integer read GetTileMatrix write SetTileMatrix;
		property TileArray[Index: Integer]: Integer read GetTileArray write SetTileArray; default;
	end;

	TGameController	= class
	private
		FView		: TGameView;
		FModel	: TGameModel;
    function GetScore: Integer;
	public
		constructor Create(ACanvas: TCanvas; AMapSize: Integer = 0);
		procedure DrawTiles;
		procedure DrawBackground;
		
		procedure RestartGame;
		procedure GenerateRandomTile;
		procedure MoveTiles(Aspect: TMoveAspect);

		property View: TGameView read FView;
		property Model: TGameModel read FModel;
		property Score: Integer read GetScore;
	end;

const
	TileSets	: array[0..15] of record
			Background	: TColor;
			FontColor	: TColor;
		end = (
			( Background: clLtGray  ),
			( Background: $00dae4ee; FontColor: clBlack;  ),	// 2
			( Background: $00c8e0ed; FontColor: clBlack;  ),	// 4
			( Background: $0079b1f2; FontColor: clCream;  ),	// 8
			( Background: $006395f5; FontColor: clCream;  ),	// 16
			( Background: $005f7cf6; FontColor: clCream;  ),	// 32
			( Background: $003b5ef6; FontColor: clCream;  ),	// 64
			( Background: $0072cfed; FontColor: clDkGray;  ),	// 128
			( Background: $002ec2ed; FontColor: clWhite;  ),	// 256
			( Background: $001ea2cd; FontColor: clCream;  ),	// 512
			( Background: $00d3f262; FontColor: $004488;  ),	// 1024
			( Background: $00c3a232; FontColor: $88ffff;  ),	// 2048
			( Background: $00a2c332; FontColor: $44ddff;  ),	// 4096
			( Background: $0088ffdd; FontColor: $0044dd;  ),	// 8192
			( Background: $00dd88ff; FontColor: clYellow;  ),	// 16384
			( Background: $00ddff88; FontColor: clCream;  )	// 32768
		);

implementation

{ TGameView }

constructor TGameView.Create(ACanvas: TCanvas; AMapSize: Integer);
begin
	FCanvas	:= ACanvas;
	MapSize	:= AMapSize;
	FBackgroundColor	:= clDkGray;
	FCanvas.Font.Name	:= 'Tahoma';
end;

procedure TGameView.DrawRoundRectAt(X, Y, Size, Round: Integer; Color: TColor);
begin
	with FCanvas do
	begin
		Pen.Color		:= Color;
		Brush.Color	:= Color;
		RoundRect(X, Y, X+Size, Y+Size, Round, Round);
	end;
end;

procedure TGameView.DrawBackground;
begin
	DrawRoundRectAt(1, 1, FMapSize-2, FMapRound-2, BackgroundColor);
end;

procedure TGameView.DrawTileTextAt(X, Y, Size: Integer; Color: TColor;
	const Text: string);
var
	sz: TSize;
begin
	with FCanvas do
	begin
		Font.Color	:= Color;
		Font.Size		:= Size;
		Font.Style	:= [fsBold];
		sz	:= TextExtent(Text);
		TextOut(X - sz.cx div 2, Y - sz.cy div 2, Text);
	end;
end;

procedure TGameView.DrawTileAtPoint(X, Y, Index: Integer);
begin
	with TileSets[Index] do
	begin
		DrawRoundRectAt(X, Y, FTileSize, FTileRound, Background);
		if ((Index<=0)or(Index>15)) then
			Exit;
		DrawTileTextAt(X+FTileSize div 2, Y+FTileSize div 2, FFontSize[Index], FontColor, IntToStr(1 shl Index));
	end;
end;

procedure TGameView.DrawTiles(const Tiles: TTileMatrix);
var
	i, j: Integer;
begin
	for i:=0 to 3 do
		for j:=0 to 3 do
		begin
			ShowTile(i, j, Tiles[i, j]);
		end;
end;

procedure TGameView.SetMapSize(const Value: Integer);
const
	Texts	: array[0..4] of string = (
			'8', '64', '256', '4096', '32768'
		);
	Ranges	: array[0..4] of Integer = (3, 6, 9, 13, 15);
var
	i, n, limit	: Integer;
	sz	: TSize;
	fs	: Integer;
begin
	FMapSize	:= Value;
	FMapRound	:= FMapSize div 20;

	FBaseTileOff	:= FMapRound div 2;
	FFullTileSize	:= (FMapSize - FBaseTileOff) div 4;
	FTileRound		:= FFullTileSize div 10;
	FTileSize			:= FFullTileSize - FBaseTileOff;

	n		:= 1;
	fs	:= 82;
{
	1~3	: 2, 4, 8
	4~6	: 16, 32, 64
	7~9 : 128, 256, 512
	10~13 : 1024, 2048, 4096, 8192
	14~15 : 16384, 32768
}
	for i:=Low(Texts) to High(Texts) do
	begin
		limit	:= FTileSize - FTileRound*2 - (5-i) * (FTileRound div 2);
		repeat
			Dec(fs);
			FCanvas.Font.Size	:= fs;
			sz	:= FCanvas.TextExtent(Texts[i]);
		until(sz.cx < limit) and (sz.cy < limit);

		repeat
			FFontSize[n]	:= fs;
			Inc(n);
		until(n>Ranges[i]);
  end;  
end;

procedure TGameView.ShowTile(Row, Col: Integer; Index: Integer);
begin
	DrawTileAtPoint(FBaseTileOff + Col*FFullTileSize, FBaseTileOff + Row*FFullTileSize, Index);
end;

procedure TGameView.AnimateNewTile(Row, Col, Index: Integer);
const
	Steps	= 5;
var
	cx, cy, i, sz, rnd, x, y	: Integer;
	color	: TColor;
begin
	ShowTile(Row, Col, 0);
	cx	:= FBaseTileOff + Col*FFullTileSize + FFullTileSize div 2;
	cy	:= FBaseTileOff + Row*FFullTileSize + FFullTileSize div 2;
	color	:= TileSets[Index].Background;
	for i:=1 to Steps-1 do
	begin
		sz	:= FFullTileSize div Steps * i;
		rnd	:= FTileRound div Steps * i;
		x	:= cx - sz div 2;
		y	:= cy - sz div 2;
		DrawRoundRectAt(x, y, sz, rnd, color);
		Application.ProcessMessages;
		Sleep(23);
	end;
	ShowTile(Row, Col, Index);
end;

procedure TGameView.AnimateMoveMerge(const Src, Dst: TTileMatrix;
	Aspect: TMoveAspect);
const
	EmptyTiles	: TTileMatrix = ( (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0) );
  SizeInc	: array[0..2] of Integer = ( 16, 10, 12 );
	Deltas	: array[TMoveAspect] of record
			rowBase, colBase, rowDelta, colDelta	: Integer;
		end = (
			( rowBase: -1; colBase:  0; rowDelta:  0; colDelta: +1 ),	// L
			( rowBase: -1; colBase:  3; rowDelta:  0; colDelta: -1 ),	// R
			( rowBase:  0; colBase: -1; rowDelta: +1; colDelta:  0 ),	// U
			( rowBase:  3; colBase: -1; rowDelta: -1; colDelta:  0 )	// D
		);
  Steps1	= 3;
var
	hotMapSrc, hotMapDst	: TTileMatrix;
	dMove	: Integer;
	outRowDelta, outColDelta	: Integer;
	inRowBase, inRowDelta, inColBase, inColDelta	: Integer;
	oRow, oCol, iRow, iCol, iRS, iCS, iO, iI	: Integer;
	r, c, dstIdx, srcIdx, i, t, x, y	: Integer;
  pMapDst	: PTileArray;
begin
	FillChar(hotMapSrc, SizeOf(hotMapSrc), 0);
	FillChar(hotMapDst, SizeOf(hotMapDst), 0);
  // Init Aspect Base and Delta
	with Deltas[Aspect] do
	begin
		if(rowBase<0)then
		begin
			outRowDelta	:= 1;
			inRowBase		:= 0;
			inRowDelta	:= 0;

			outColDelta	:= 0;
			inColBase		:= colBase;
			inColDelta	:= colDelta;
		end else
		begin
			outRowDelta	:= 0;
			inRowBase		:= rowBase;
			inRowDelta	:= rowDelta;

			outColDelta	:= 1;
			inColBase		:= 0;
			inColDelta	:= 0;
		end;
	end;


	// Compare and Get Actions - save to hotMaps
	{	[Actions]
		Src
			0	- None
			1~3 - Move Factor
		Dst
			0	- Normal
      1 - hot
	}
	oRow	:= 0;
	oCol	:= 0;
	for iO:=0 to 3 do
	begin
		iRow	:= inRowBase;
		iCol	:= inColBase;
		iRS		:= iRow;
		iCS		:= iCol;
		for iI:=0 to 3 do
		begin
			dstIdx	:= Dst[oRow+iRow, oCol+iCol];
			if(dstIdx=0)then
				Break;

			repeat
				srcIdx	:= Src[oRow+iRS, oCol+iCS];
				Inc(iRS, inRowDelta);
				Inc(iCS, inColDelta);
			until(srcIdx<>0);

			r	:= iRS-inRowDelta;
			c	:= iCS-inColDelta;

			if(srcIdx=dstIdx)then
			begin
				hotMapSrc[oRow+r, oCol+c]	:= Abs(r - iRow + c - iCol);
			end else
			begin
				hotMapDst[oRow+iRow, oCol+iCol]	:= 1;
				hotMapSrc[oRow+r, oCol+c]	:= Abs(r - iRow + c - iCol);
				repeat
					srcIdx	:= Src[oRow+iRS, oCol+iCS];
					Inc(iRS, inRowDelta);
					Inc(iCS, inColDelta);
				until(srcIdx<>0);
				r	:= iRS-inRowDelta;
				c	:= iCS-inColDelta;
				hotMapSrc[oRow+r, oCol+c]	:= Abs(r - iRow + c - iCol);
			end;
			
			Inc(iRow, inRowDelta);
			Inc(iCol, inColDelta);
		end;
		Inc(oRow, outRowDelta);
		Inc(oCol, outColDelta);
	end;

	// Move
	dMove	:= FFullTileSize div Steps1;
  for i := 1 to Steps1-1 do
  begin
    DrawBackground;
    DrawTiles(EmptyTiles);
    for r := 0 to 3 do
      for c := 0 to 3 do
    begin
    	t	:= Src[r, c];
    	if(t=0)then
      	Continue;
			DrawTileAtPoint(
      	FBaseTileOff + c*FFullTileSize - hotMapSrc[r, c]*i*dMove*inColDelta,
        FBaseTileOff + r*FFullTileSize - hotMapSrc[r, c]*i*dMove*inRowDelta,
        t);
    end;
    Application.ProcessMessages;
    Sleep(27);
  end;

  // Merge
  t	:= 0;
  pMapDst	:= @hotMapDst;
  for i := 0 to 15 do
    Inc(t, pMapDst[i]);

  if(t>0)then
  begin
  	for i := Low(SizeInc) to High(SizeInc) do
    begin
      DrawBackground;
      DrawTiles(Dst);

      for r := 0 to 3 do
        for c := 0 to 3 do
      begin
        if(hotMapDst[r, c]=0)then
          Continue;

        dstIdx	:= Dst[r, c];
        with TileSets[dstIdx] do
        begin
        	x	:= FBaseTileOff + c*FFullTileSize;
          y	:= FBaseTileOff + r*FFullTileSize;
          t	:= FTileSize div SizeInc[i];

          DrawRoundRectAt(
          	x - t,
            y - t,
            FTileSize + t*2,
            FTileRound,
            Background);

          DrawTileTextAt(
          	x+FTileSize div 2,
            y+FTileSize div 2,
            FFontSize[dstIdx],
            FontColor,
            IntToStr(1 shl dstIdx));
        end;
      end;

      Application.ProcessMessages;
      Sleep(60);
    end;
  end;

	// done
  DrawBackground;
  DrawTiles(Dst);
end;

{ TGameModel }

constructor TGameModel.Create;
begin
	PTiles	:= @FTiles;
end;

function TGameModel.GenerateRandomTile: Integer;
var
	available		: TTileArray;
	pavailable	: PTileArray;
	count, i	: Integer;
begin
	// get available tile indexes
	count	:= 0;
	pavailable	:= @available;
	for i:=0 to High(PTiles^) do
	begin
		if(PTiles[i]=0)then
		begin
			pavailable[count]	:= i;
			Inc(count);
		end;
	end;

	// generate random position and value
	Result	:= pavailable[Random(count)];
	PTiles[Result]	:= 1 + Ord(Random(100)>=90);
end;

function TGameModel.GetCanMove: Boolean;
var
	i, j, k, tc, tn	: Integer;
begin
			Result	:= True;
	for i:=0 to High(PTiles^) do
	begin
		if(PTiles[i]=0)then
			Exit;
	end;

	for i:=0 to 2 do
	begin
		for j:=0 to 3 do
		begin
			tc	:= FTiles[i, j];
			if(tc=0)then
				Continue;

			// find right
			for k:=j+1 to 3 do
			begin
				tn	:= FTiles[i, k];
				if(tn=0)then
					Continue
				else if(tn=tc)then
					Exit
				else
					Break;
			end;

			// find down
			for k:=i+1 to 3 do
			begin
				tn	:= FTiles[k, j];
				if(tn=0)then
					Continue
				else if(tn=tc)then
					Exit
				else
					Break;
			end;
		end;
	end;

	Result	:= False;  
end;

function TGameModel.GetTileArray(Index: Integer): Integer;
begin
	Result	:= PTiles[Index];
end;

function TGameModel.GetTileMatrix(Row, Col: Integer): Integer;
begin
	Result	:= FTiles[Row, Col];
end;

function TGameModel.MoveTiles(Aspect: TMoveAspect; out ScoreToAdd: Integer): Boolean;
const
	MergeDeltas	: array[TMoveAspect] of record
			rowBase, colBase, rowDelta, colDelta	: Integer;
		end = (
			( rowBase: 0; colBase: 0; rowDelta: +4; colDelta: +1 ),	// L
			( rowBase: 0; colBase: 3; rowDelta: +4; colDelta: -1 ),	// R
			( rowBase: 0; colBase: 0; rowDelta: +1; colDelta: +4 ),	// U
			( rowBase: 3; colBase: 0; rowDelta: +1; colDelta: -4 )	// D
		);
var
	oldTiles, newTiles	: TTileArray;
	nBaseSrc, nIdxDest	: Integer;
	i, j, k, tc, tn	: Integer;
begin
	oldTiles	:= PTiles^;
	FillChar(newTiles, SizeOf(newTiles), 0);
	ScoreToAdd	:= 0;
	
	with MergeDeltas[Aspect] do
	begin
		for i:=0 to 3 do
		begin
			nBaseSrc	:= rowBase * 4 + rowDelta * i + colBase;
			nIdxDest	:= nBaseSrc;

      tc	:= 0;
			j	:= 0;
			while(j<=3)do
			begin
				tc	:= oldTiles[nBaseSrc + colDelta * j];
				if(tc=0)then	// empty
				begin
          Inc(j);
					Continue;
				end;

				k	:= j+1;
				while(k<=3)do
				begin
					tn	:= oldTiles[nBaseSrc + colDelta * k];
					if(tn=0)then // empty
					begin
						Inc(k);
					end
					else if(tn=tc)then	// same
					begin
						newTiles[nIdxDest] := tc+1;
						Inc(ScoreToAdd, 2 shl tc);
						tc	:= 0;
						Inc(nIdxDest, colDelta);
						Inc(k);
						Break;
					end else	// different
					begin
						newTiles[nIdxDest] := tc;
						Inc(nIdxDest, colDelta);
						Break;
					end;
				end;
				j	:= k;
			end;

			if(tc<>0)then
				newTiles[nIdxDest] := tc;
    end;  
  end;  

	Result	:= (ScoreToAdd>0) or not CompareMem(@oldTiles, @newTiles, SizeOf(oldTiles));
	if(Result)then
		PTiles^ := newTiles;
end;

procedure TGameModel.RestartGame;
begin
	FScore	:= 0;
	FillChar(FTiles, SizeOf(FTiles), 0);
	GenerateRandomTile;
	GenerateRandomTile;
end;

procedure TGameModel.SetTileArray(Index: Integer; const Value: Integer);
begin
	PTiles[Index]	:= Value;
end;

procedure TGameModel.SetTileMatrix(Row, Col: Integer;
	const Value: Integer);
begin
	FTiles[Row, Col]	:= Value;
end;

{ TGameController }

constructor TGameController.Create(ACanvas: TCanvas; AMapSize: Integer);
begin
	if(AMapSize=0)then
		AMapSize	:= 600;
	FView		:= TGameView.Create(ACanvas, AMapSize);
	FModel	:= TGameModel.Create;
end;

procedure TGameController.DrawBackground;
begin
	FView.DrawBackground;
end;

procedure TGameController.DrawTiles;
begin
	FView.DrawTiles(FModel.FTiles);
end;

procedure TGameController.GenerateRandomTile;
var
	idx, r, c	: Integer;
begin
	idx	:= FModel.GenerateRandomTile;
	r		:= idx div 4;
	c		:= idx mod 4;
	idx	:= FModel[idx];
	
	DrawBackground;
	DrawTiles;
	FView.AnimateNewTile(r, c, idx);
end;

function TGameController.GetScore: Integer;
begin
	Result	:= FModel.Score;
end;

procedure TGameController.MoveTiles(Aspect: TMoveAspect);
var
	delta	: Integer;
	old	: TTileMatrix;
begin
	old	:= FModel.FTiles;
	if(FModel.MoveTiles(Aspect, delta))then
	begin
		FModel.Score	:= FModel.Score + delta;
		FView.AnimateMoveMerge(old, FModel.FTiles, Aspect);
		GenerateRandomTile;
  end;  
end;

procedure TGameController.RestartGame;
begin
	FModel.RestartGame;
	DrawBackground;
	DrawTiles;
end;

end.
