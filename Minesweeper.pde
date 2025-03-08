import de.bezier.guido.*;

import de.bezier.guido.*;
int screenSize = 400;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
int NUM_ROWS = 10;
int NUM_COLS = 10;
boolean lose = false;
boolean win = false;
boolean firstClick = true;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
   
    // make the manager
    Interactive.make( this );
   
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
         buttons[r][c] = new MSButton(r, c);
      }
    }
   
   
    setMines((int)((NUM_ROWS * NUM_COLS) * 0.12));
}
public void setMines(int minesNum)
{
    for (int i = 0; i < minesNum; i++) {
        int row = (int)(Math.random()*NUM_ROWS);
        int cols = (int)(Math.random()*NUM_COLS);
        if (!mines.contains(buttons[row][cols])) {
            mines.add(buttons[row][cols]);
            continue;
        }
        i--;
    }
}

public void draw ()
{
    background(0);

}

public void displayLosingMessage()
{
    text("YOU LOSE!!", width/2, height/2);
}
public void displayWinningMessage()
{
    text("YOU WIN!!", width/2, height/2);
}
public boolean isValid(int r, int c)
{
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
        return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int r = row - 1; r <= row + 1; r++) {
        for (int c = col - 1; c <= col + 1; c++) {
            if (isValid(r, c) && mines.contains(buttons[r][c])) numMines++;
        }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col )
    {
         width = screenSize/NUM_COLS;
         height = screenSize/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed ()
    {  
       if (mouseButton == LEFT && !isFlagged()) clicked = true;
       if (firstClick && clicked) {
            int minesRemoved = 0;
            for (int r = myRow - 1; r <= myRow + 1; r++) {
                for (int c = myCol - 1; c <= myCol + 1; c++) {
                    if (isValid(r, c) && mines.contains(buttons[r][c])) {
                      mines.remove(mines.indexOf(buttons[r][c]));
                      minesRemoved++;
                    }  
                }
            }
            if (minesRemoved > 0) setMines(minesRemoved);
            firstClick = false;
        }
       
        if (mouseButton == RIGHT && !clicked) {
            if (isFlagged() == true) {
              flagged = false;
            }
            else flagged = true;
        }
        if (clicked) {
          if (mines.contains(this) && !isFlagged()) {
              lose = true;
              for (int i = 0; i < mines.size(); i++) {
                mines.get(i).clicked = true;
              }
          } else if (countMines(myRow, myCol) > 0 && !mines.contains(this)) {
            setLabel(countMines(myRow, myCol));
          } else if (countMines(myRow, myCol) == 0)
            for (int row = myRow-1; row <= myRow+1; row++)
               for (int col = myCol-1; col <= myCol+1; col++)
                 if (isValid(row, col) && !buttons[row][col].clicked) buttons[row][col].mousePressed();
        }
           int tilesToWin = NUM_ROWS * NUM_COLS;
           int tilesClicked = 0;
           int minesFlagged = 0;
           for (int row = 0; row < NUM_ROWS; row++)
             for (int col = 0; col < NUM_COLS; col++)
               if (buttons[row][col].isFlagged() && mines.contains(buttons[row][col])) minesFlagged++;
               else if (buttons[row][col].clicked) tilesClicked++;
           if (tilesClicked + minesFlagged == tilesToWin && (isFlagged() || !mines.contains(this)) && lose == false) win = true;
       
    }
   
    public void draw ()
    {
        if (win) {
          textSize(50);
          fill(0, 255, 0);
          displayWinningMessage();
          textSize(11);
        }
        if (isFlagged())
            fill(0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );
        if (lose && mines.contains(this)) {
          textSize(50);
          fill(50, 0, 0);
          displayLosingMessage();
          fill(255, 0, 0);
          textSize(11);
        }
        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
