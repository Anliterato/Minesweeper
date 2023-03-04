import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    setMines();
}
public void setMines()
{
  for(int numMine = 0; numMine < 50; numMine++){
    int rMine = (int)(Math.random() * NUM_ROWS);
    int cMine = (int)(Math.random() * NUM_COLS);
    if(!mines.contains(buttons[rMine][cMine])){
      mines.add(buttons[rMine][cMine]);
    } else {
      numMine--; //sets for loop back if no mines are added
    }
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  for(int i = 0; i < mines.size(); i++){
    if(!mines.get(i).isFlagged()){
      return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("o");
  buttons[9][8].setLabel("u");
  buttons[9][10].setLabel("L");
  buttons[9][11].setLabel("o");
  buttons[9][12].setLabel("s");
  buttons[9][13].setLabel("e");
    for(int i = 0; i < mines.size(); i++){
      mines.get(i).setClick(true);
    }
}
public void displayWinningMessage()
{
  buttons[9][7].setLabel("Y");
  buttons[9][8].setLabel("o");
  buttons[9][9].setLabel("u");
  buttons[9][11].setLabel("W");
  buttons[9][12].setLabel("i");
  buttons[9][13].setLabel("n");
}
public boolean isValid(int r, int c)
{
  if(r < 0 || c < 0 || r >= NUM_ROWS || c >= NUM_COLS){
    return false;
  } else {
    return true;
  }
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row - 1; r <= row + 1; r++){
      for(int c = col -1; c <= col + 1; c++){
        if(isValid(r,c)==true){
          if(mines.contains(buttons[r][c])){
            numMines++;
          }
        }
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
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
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
        if(mouseButton == LEFT){
          clicked = true;
        }
        if(mouseButton == RIGHT){
          flagged = !flagged;
        } else if(mines.contains(this)){
          displayLosingMessage();
        } else if(countMines(myRow,myCol) > 0){
          myLabel = "" + countMines(myRow,myCol);
        } else {
          for(int r = myRow - 1; r <= myRow + 1; r++){
            for(int c = myCol - 1; c <= myCol + 1; c++){
              if(isValid(r,c) && !buttons[r][c].clicked){
                if(!mines.contains(buttons[r][c]) && r != myRow || c!= myCol){
                    buttons[r][c].mousePressed(); 
                }
              }
            }
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this)) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill(100);
        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public void setClick(boolean status){
      clicked = status;
    }
}
