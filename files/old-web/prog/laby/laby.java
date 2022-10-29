/* LABY - (c) 2001 Rémi Peyronnet */

import java.awt.*;
import java.applet.*;
import java.util.Random;

/** 
 * A good game.<p>
 *
 
 * @version 	0.01, 19/10/2001
 * @author Rémi Peyronnet
 */

public class laby extends Applet  {

    // Exceptions
    class Exception_NoMoreCase extends Exception {};
    class Exception_NoFoundCase extends Exception {};

    // These vars describe the size of the panel.
    final static short xmaxdef = 50;
    final static short ymaxdef = 30;
    final static boolean updt = true;
    final static boolean dbg = false;
    int xmax, ymax;

    // Physical size of the panel
	Dimension d;
    int dx, dy, xshift, yshift;

    // Directions
    final static short dir[]= {0,1,1,0,0,-1,-1,0};

    // Attributes
    final static short murX = 1;
    final static short murY = 2;
    final static short fait = 4;
    final static short bord = 8;

    // Laby Data
    short laby[][];
    Random random;
   
    // This method is called when it is an applet
    public void init()
    {
     System.out.print("Laby - 2001 RP.\n");
     try { xmax=Integer.parseInt(getParameter("xmax")); } catch (Exception e) { xmax = xmaxdef; }
     try { ymax=Integer.parseInt(getParameter("ymax")); } catch (Exception e) { ymax = ymaxdef; }
     System.out.print(" * Xmax = "+xmax+"\n");
     System.out.print(" * Ymax = "+ymax+"\n");
     d = getSize();
     dx = (int)Math.floor(d.width / (xmax+1));
     dy = (int)Math.floor(d.height / (ymax+1));
     xshift = (d.width - xmax*dx)/2;
     yshift = (d.height - ymax*dy)/2;
     init_laby();
     repaint();
    }

    public void start()
    {
     gen_laby();
     repaint();
    }

    public void init_laby()
    {
     laby = new short[ymax+2][xmax+2];
     // Fill the laby with walls
     for (int i=0;i<xmax+2;i++)
      for (int j=0;j<ymax+2;j++)
       laby[j][i]=murX | murY;
     // Set the limits
     for (int i=0;i<ymax+2;i++) 
     { 
      laby[i][0] = murX | murY | fait | bord;
      laby[i][xmax+1] = murX | murY | fait | bord;
     }
     for (int i=0;i<xmax+2;i++) 
     { 
      laby[0][i] = murX | murY | fait | bord;
      laby[ymax+1][i] = murX | murY | fait | bord;
     }
     random = new Random();
    }

    /* This function is very important : the order of case will
     *  deeply affect the maze.
     * You should replace this sample function by a more sophisticated
     * path finder.
     * @throws Exception when no more case are left.
     */
    public int[] getNextCase(int last[]) 
     throws Exception_NoMoreCase
    {
     int coo[];
     // First time ?
     coo = last;
     if (coo[0] == -1) 
     {
      coo[0] = 1;
      coo[1] = 1;
      laby[coo[1]][coo[0]] |= fait;
     }
     
     while ((laby[coo[1]][coo[0]] & fait) != 0)
     {
      if (coo[0] != (xmax +1)) { coo[0]++; }
       else if (coo[1] != (ymax +1)) { coo[0] = 1; coo[1]++; }
       else throw new Exception_NoMoreCase();
     }
     return coo;
    }

    public int[] findCase(int[] cur, boolean need)
     throws Exception_NoFoundCase
    {
     int idir = random.nextInt() % 4;
     idir = (idir < 0)?-idir:idir;
     int ret[] = new int[2];
     for (int i =0; i<4; i++)
     {
      if ( (((laby[cur[1]+dir[2*idir+1]][cur[0]+dir[2*idir]] & fait) != 0) == need) &&
           ((laby[cur[1]+dir[2*idir+1]][cur[0]+dir[2*idir]] & bord) == 0) )
       {    
        ret[0]=cur[0]+dir[2*idir];
        ret[1]=cur[1]+dir[2*idir+1];
        return ret;
       }
      idir=(idir==3)?0:idir+1;
     }
     throw new Exception_NoFoundCase();
    }

    public void dig(int case1[], int case2[])
    {
     if (case1[0]==case2[0]) 
      eraseCase(case1[0],(case1[1]<case2[1])?case1[1]:case2[1],murY);
      else eraseCase((case1[0]<case2[0])?case1[0]:case2[0],case1[1],murX);
    }

    public void gen_laby()
    {
     int cur[], tmp[], first[]={-1,-1};
     try  { while (true) {
      first = getNextCase(first);
      if (dbg) System.out.print("Current X="+first[0]+", Y="+first[1]+"\n");
      faitCase(first[0],first[1]);
      // Link to a previous case.
      tmp = findCase(first, true);
      if (dbg) System.out.print(" * Link X="+tmp[0]+", Y="+tmp[1]+"\n");
      dig(first,tmp);
      // Dig until an exception occurs
      cur = first;
      try { while (true) {
       tmp = findCase(cur, false);
       if (dbg) System.out.print(" * Dig X="+tmp[0]+", Y="+tmp[1]+"\n");
       faitCase(tmp[0],tmp[1]);
       dig(cur,tmp);
       cur=tmp;
      } } catch (Exception_NoFoundCase e) {};
     } } catch (Exception_NoMoreCase e) {}
         catch (Exception_NoFoundCase e) { System.out.print("Uh ?! bug.\n");};
    }

    // Destroy the application
    public void destroy() 
    {
    }
    
    // DISPLAY SECTION ==================================================
    
    // This function adds the border lines according to the mask.
    public void affCase(Graphics g, int l, int x, int y)
    {
     if ((l & murX) != 0) 
      { 
       g.setColor(Color.black); 
       g.drawLine(x*dx+xshift+dx, y*dy+yshift, x*dx+xshift + dx, y*dy+yshift+dy);
      }
      else 
      { 
       g.setColor(Color.white); 
       g.drawLine(x*dx+xshift+dx, y*dy+yshift+1, x*dx+xshift + dx, y*dy+yshift+dy-1);
      }
     //g.drawLine(x*dx+xshift+dx, y*dy+yshift, x*dx+xshift + dx, y*dy+yshift+dy);
     if ((l & murY) != 0) 
      { 
       g.setColor(Color.black); 
       g.drawLine(x*dx+xshift, y*dy+yshift+dy, x*dx+xshift + dx, y*dy+yshift+dy);
      } 
      else 
      {
       g.setColor(Color.white); 
       g.drawLine(x*dx+xshift+1, y*dy+yshift+dy, x*dx+xshift + dx-1, y*dy+yshift+dy);
      }
     //g.drawLine(x*dx+xshift, y*dy+yshift+dy, x*dx+xshift + dx, y*dy+yshift+dy);
    }

    // This paint method redraws all from nothing.
    // an offscreen rendering Graphics object is used.
    // it displays the background, and calls paint_blocs
    public void paint(Graphics g) 
    {
     Image offscreen;
     Graphics og;
  	 offscreen = createImage(d.width, d.height);
	 og = offscreen.getGraphics();
     og.setColor(Color.white);
     og.fillRect(0,0,d.width,d.height);
	 og.setColor(Color.black);
     //og.setFont(new Font(og.getFont().getName(),Font.BOLD,24));
     //og.drawString("Test",727,160);
     og.drawLine(xshift,yshift,xshift+dx*xmax,yshift);
     og.drawLine(xshift,yshift,xshift,yshift+dy*ymax);
     paint_cases(og, 1, 1, xmax+1, ymax+1);
     g.drawImage(offscreen, 0, 0, this);
    }

    // Paints blocs in the rect xmin,ymin,xmax,ymax.
    public void paint_cases(Graphics g, int xmin, int ymin, int xmax, int ymax)
    {
     for (int i=xmin; i<xmax; i++)
      for (int j=ymin; j<ymax; j++)
       { 
        affCase(g, laby[j][i],i-1,j-1);
       }
    }

    // Sets the bloc to the provided value, and marks it as to be updated.
    public void setCase(int x, int y, int v)
    {
     laby[y][x]=(short)v;
     if (updt)  { affCase(this.getGraphics(),v,x,y); }
    }

    public void eraseCase(int x, int y, int mask)
    {
     setCase(x,y,laby[y][x] & (~mask));
    }

    public void faitCase(int x, int y)
    {
     laby[y][x] |=(short)fait;
    }


    public String getAppletInfo() {
	    return "Laby";
    }

}

/* Changelog
 - 11/11/01 : First line of code
*/
